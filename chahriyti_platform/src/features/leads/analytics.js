import { wilayaName } from '../../config/wilayas';
import { LEAD_STATUSES } from './leadStatus';

const DAY_MS = 24 * 60 * 60 * 1000;
const FOLLOW_UP_AFTER_MS = 2 * DAY_MS;

const SALARY_BUCKETS = [
  { label: 'أقل من 30 ألف', max: 30000 },
  { label: '30 – 50 ألف', max: 50000 },
  { label: '50 – 80 ألف', max: 80000 },
  { label: '80 – 120 ألف', max: 120000 },
  { label: '120 ألف فأكثر', max: Infinity },
];

const toDate = (ts) => (ts?.toDate ? ts.toDate() : ts ? new Date(ts) : null);
const dayKey = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
const monthKey = (d) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`;
const dayStart = (d) => new Date(d.getFullYear(), d.getMonth(), d.getDate());
const pct = (part, total) => (total ? Math.round((part / total) * 100) : 0);
const fmt = (n) => n.toLocaleString('en-US');

function countBy(items, keyOf) {
  const map = new Map();
  for (const item of items) {
    const key = keyOf(item);
    if (key === null || key === undefined || key === '') continue;
    map.set(key, (map.get(key) ?? 0) + 1);
  }
  return [...map.entries()].map(([key, count]) => ({ key, count })).sort((a, b) => b.count - a.count);
}

// Top n rows, the rest folded into one "أخرى" row
function topWithOther(rows, n) {
  if (rows.length <= n) return rows;
  const rest = rows.slice(n).reduce((sum, r) => sum + r.count, 0);
  return [...rows.slice(0, n), { key: 'other', label: 'أخرى', count: rest }];
}

function median(values) {
  if (!values.length) return 0;
  const s = [...values].sort((a, b) => a - b);
  const mid = Math.floor(s.length / 2);
  return s.length % 2 ? s[mid] : Math.round((s[mid - 1] + s[mid]) / 2);
}

/**
 * Leads over time, split by source. Daily up to ~3 months, monthly beyond.
 */
function timeline(leads, range, now) {
  const dates = leads.map((l) => toDate(l.submittedAt)).filter(Boolean);
  if (!dates.length) return { points: [], unit: 'day' };

  const first = range.from ?? new Date(Math.min(...dates));
  const last = range.to ? new Date(range.to.getTime() - 1) : now;
  const spanDays = Math.round((dayStart(last) - dayStart(first)) / DAY_MS) + 1;
  const unit = spanDays > 92 ? 'month' : 'day';
  const keyOf = unit === 'day' ? dayKey : monthKey;

  const buckets = new Map();
  const cursor = dayStart(first);
  while (cursor <= last) {
    const key = keyOf(cursor);
    if (!buckets.has(key)) {
      buckets.set(key, {
        key,
        label: unit === 'day'
          ? cursor.toLocaleDateString('ar-DZ', { day: 'numeric', month: 'short' })
          : cursor.toLocaleDateString('ar-DZ', { month: 'short', year: 'numeric' }),
        app: 0,
        store: 0,
      });
    }
    cursor.setDate(cursor.getDate() + 1);
  }

  for (const lead of leads) {
    const d = toDate(lead.submittedAt);
    const bucket = d && buckets.get(keyOf(d));
    if (bucket) bucket[lead.source === 'woocommerce' ? 'store' : 'app'] += 1;
  }
  return { points: [...buckets.values()], unit, spanDays };
}

const hourLabel = (h) => `${String(h).padStart(2, '0')}:00`;

/**
 * Leads per hour of day (0–23, local time), split by source.
 */
function hourly(leads) {
  const hours = Array.from({ length: 24 }, (_, h) => ({ key: h, label: hourLabel(h), app: 0, store: 0, total: 0 }));
  for (const lead of leads) {
    const d = toDate(lead.submittedAt);
    if (!d) continue;
    const bucket = hours[d.getHours()];
    bucket[lead.source === 'woocommerce' ? 'store' : 'app'] += 1;
    bucket.total += 1;
  }
  return hours;
}

/**
 * Everything the analytics section shows, computed from the period's leads.
 */
export function analyzeLeads(leads, range, now = new Date()) {
  const total = leads.length;
  const app = leads.filter((l) => l.source !== 'woocommerce');
  const store = leads.filter((l) => l.source === 'woocommerce');
  const statusOf = (l) => l.status ?? 'pending';

  const { points, unit, spanDays } = timeline(leads, range, now);
  const hours = hourly(leads);

  const status = Object.entries(LEAD_STATUSES).map(([key, s]) => ({
    key,
    label: s.label,
    dot: s.dot,
    count: leads.filter((l) => statusOf(l) === key).length,
  }));

  const wilayas = topWithOther(
    countBy(leads, (l) => l.wilayaCode || null).map((r) => ({ ...r, label: wilayaName(r.key) })),
    7,
  );

  const salaries = app.map((l) => Number(l.salary) || 0).filter((s) => s > 0);
  const salary = SALARY_BUCKETS.map((b, i) => ({
    key: b.label,
    label: b.label,
    count: salaries.filter((s) => s < b.max && s >= (i ? SALARY_BUCKETS[i - 1].max : 0)).length,
  }));

  const ages = countBy(app, (l) => l.ageGroup).map((r) => ({ ...r, label: r.key }));
  const goals = topWithOther(countBy(app.flatMap((l) => l.goals ?? []), (g) => g).map((r) => ({ ...r, label: r.key })), 5);
  const appWithGoals = app.filter((l) => l.goals?.length).length;

  // ── Insights: short, actionable sentences ──
  const insights = [];

  const waiting = leads.filter((l) => {
    const d = toDate(l.submittedAt);
    return statusOf(l) === 'pending' && d && now - d > FOLLOW_UP_AFTER_MS;
  }).length;
  if (waiting) {
    insights.push({ tone: 'warning', text: `${fmt(waiting)} مسجلاً في الانتظار منذ أكثر من يومين — تواصل معهم قبل أن يبردوا.` });
  }

  if (points.length > 1) {
    const busiest = points.reduce((a, b) => (b.app + b.store > a.app + a.store ? b : a));
    const busiestTotal = busiest.app + busiest.store;
    if (busiestTotal) {
      const perDay = total / Math.max(spanDays, 1);
      insights.push({
        tone: 'info',
        text: `المعدل ${perDay >= 10 ? Math.round(perDay) : perDay.toFixed(1)} مسجل يومياً، وأعلى ${unit === 'day' ? 'يوم' : 'شهر'} كان ${busiest.label} بـ ${fmt(busiestTotal)} مسجلاً.`,
      });
    }
  }

  // Busiest 3-hour window (wraps past midnight)
  const timed = hours.reduce((sum, h) => sum + h.total, 0);
  if (timed >= 10) {
    let best = 0;
    let bestCount = -1;
    for (let h = 0; h < 24; h++) {
      const c = hours[h].total + hours[(h + 1) % 24].total + hours[(h + 2) % 24].total;
      if (c > bestCount) { best = h; bestCount = c; }
    }
    insights.push({
      tone: 'info',
      text: `أفضل وقت: بين ${hourLabel(best)} و${hourLabel((best + 3) % 24)} — ${pct(bestCount, timed)}% من التسجيلات.`,
    });
  }

  if (wilayas.length && wilayas[0].key !== 'other') {
    insights.push({ tone: 'info', text: `${wilayas[0].label} في المقدمة بـ ${fmt(wilayas[0].count)} مسجلاً (${pct(wilayas[0].count, total)}% من الإجمالي).` });
  }

  const converted = (list) => list.filter((l) => statusOf(l) === 'converted').length;
  if (app.length && store.length) {
    insights.push({
      tone: 'success',
      text: `نسبة التفعيل: التطبيق ${pct(converted(app), app.length)}% · المتجر ${pct(converted(store), store.length)}%.`,
    });
  } else if (total) {
    insights.push({ tone: 'success', text: `نسبة التفعيل ${pct(converted(leads), total)}% (${fmt(converted(leads))} من ${fmt(total)}).` });
  }

  if (salaries.length) {
    insights.push({ tone: 'info', text: `الراتب الوسيط للمسجلين من التطبيق ${fmt(median(salaries))} دج.` });
  }

  if (goals.length && goals[0].key !== 'other' && appWithGoals) {
    insights.push({ tone: 'info', text: `أكثر هدف مطلوب: «${goals[0].label}» (${pct(goals[0].count, appWithGoals)}% من مسجلي التطبيق).` });
  }

  return {
    total,
    appCount: app.length,
    storeCount: store.length,
    points,
    unit,
    hours,
    status,
    wilayas,
    salary,
    salaryTotal: salaries.length,
    ages,
    goals,
    insights,
  };
}
