import React, { useEffect, useMemo, useState } from 'react';
import {
  ResponsiveContainer,
  BarChart,
  Bar,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
} from 'recharts';
import { Spinner } from '../../../components/ui';
import { getLeadsForAnalytics } from '../../../services/firestore';
import { analyzeLeads } from '../analytics';

// Categorical pair for source (validated: CVD ΔE 24.7, normal ΔE 33.6, ≥3:1 on white)
const SOURCE_COLORS = { app: '#2a78d6', store: '#eb6834' };
// Single-series magnitude bars use the brand hue
const BAR_COLOR = '#0D6E6E';

const INSIGHT_TONES = {
  warning: { box: 'bg-amber-50 ring-amber-200', icon: 'text-amber-600', path: 'M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z' },
  success: { box: 'bg-emerald-50 ring-emerald-200', icon: 'text-emerald-600', path: 'M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z' },
  info: { box: 'bg-surface ring-border', icon: 'text-primary', path: 'M12 18v-5.25m0 0a6.01 6.01 0 001.5-.189m-1.5.189a6.01 6.01 0 01-1.5-.189m3.75 7.478a12.06 12.06 0 01-4.5 0m3.75 2.383a14.406 14.406 0 01-3 0M14.25 18v-.192c0-.983.658-1.823 1.508-2.316a7.5 7.5 0 10-7.517 0c.85.493 1.509 1.333 1.509 2.316V18' },
};

function Card({ title, subtitle, children, className = '' }) {
  return (
    <div className={`bg-card border border-border rounded-2xl p-5 shadow-card ${className}`}>
      <div className="mb-4">
        <h3 className="text-sm font-semibold text-text-primary">{title}</h3>
        {subtitle && <p className="text-xs text-text-secondary mt-0.5">{subtitle}</p>}
      </div>
      {children}
    </div>
  );
}

function Empty() {
  return <p className="text-sm text-text-secondary py-6 text-center">لا توجد بيانات كافية لهذه الفترة</p>;
}

/**
 * Ranked horizontal bars in plain HTML: label, bar, count (and share on hover).
 */
function BarList({ rows, total, color = BAR_COLOR, dotOf }) {
  const max = Math.max(...rows.map((r) => r.count), 1);
  if (!rows.some((r) => r.count)) return <Empty />;
  return (
    <ul className="space-y-3">
      {rows.map((r) => (
        <li key={r.key} title={`${r.label}: ${r.count} (${total ? Math.round((r.count / total) * 100) : 0}%)`}>
          <div className="flex items-center justify-between gap-3 text-sm mb-1">
            <span className="flex items-center gap-2 text-text-primary truncate">
              {dotOf && <span className={`w-2 h-2 rounded-full shrink-0 ${dotOf(r)}`} />}
              {r.label}
            </span>
            <span className="text-text-secondary tabular-nums shrink-0">
              {r.count.toLocaleString('en-US')}
              <span className="text-xs mr-1.5">{total ? `${Math.round((r.count / total) * 100)}%` : ''}</span>
            </span>
          </div>
          <div className="h-2 rounded-full bg-divider overflow-hidden">
            <div
              className="h-full rounded-full transition-[width] duration-500"
              style={{ width: `${(r.count / max) * 100}%`, backgroundColor: color }}
            />
          </div>
        </li>
      ))}
    </ul>
  );
}

function TimelineTooltip({ active, payload, label }) {
  if (!active || !payload?.length) return null;
  const app = payload.find((p) => p.dataKey === 'app')?.value ?? 0;
  const store = payload.find((p) => p.dataKey === 'store')?.value ?? 0;
  return (
    <div dir="rtl" className="bg-white rounded-xl shadow-elevated border border-border/60 px-4 py-3 text-sm min-w-[150px]">
      <p className="text-xs text-text-secondary mb-2">{label}</p>
      {[['app', 'التطبيق', app], ['store', 'المتجر', store]].map(([key, name, value]) => (
        <div key={key} className="flex items-center justify-between gap-4">
          <span className="flex items-center gap-2 text-text-primary">
            <span className="w-2.5 h-2.5 rounded-sm" style={{ backgroundColor: SOURCE_COLORS[key] }} />
            {name}
          </span>
          <span className="font-semibold tabular-nums">{value}</span>
        </div>
      ))}
      <div className="flex justify-between gap-4 border-t border-border mt-2 pt-2 font-semibold">
        <span>المجموع</span>
        <span className="tabular-nums">{app + store}</span>
      </div>
    </div>
  );
}

function Timeline({ points, unit }) {
  if (!points.some((p) => p.app + p.store)) return <Empty />;
  return (
    <>
      <div className="flex items-center gap-4 text-xs text-text-secondary mb-3">
        {[['app', 'التطبيق'], ['store', 'المتجر']].map(([key, name]) => (
          <span key={key} className="flex items-center gap-1.5">
            <span className="w-2.5 h-2.5 rounded-sm" style={{ backgroundColor: SOURCE_COLORS[key] }} />
            {name}
          </span>
        ))}
      </div>
      <div dir="ltr" className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={points} margin={{ top: 4, right: 4, bottom: 0, left: -20 }} barCategoryGap={unit === 'day' && points.length > 20 ? 2 : '25%'}>
            <CartesianGrid vertical={false} stroke="#F1F5F9" />
            <XAxis
              dataKey="label"
              tickLine={false}
              axisLine={{ stroke: '#E2E8F0' }}
              tick={{ fontSize: 11, fill: '#94A3B8' }}
              interval="preserveStartEnd"
              minTickGap={16}
            />
            <YAxis allowDecimals={false} tickLine={false} axisLine={false} tick={{ fontSize: 11, fill: '#94A3B8' }} />
            <Tooltip content={<TimelineTooltip />} cursor={{ fill: 'rgba(13,110,110,0.06)' }} />
            {/* Surface-colored stroke = 2px gap between stacked segments */}
            <Bar dataKey="app" stackId="s" fill={SOURCE_COLORS.app} stroke="#fff" strokeWidth={1} />
            <Bar dataKey="store" stackId="s" fill={SOURCE_COLORS.store} stroke="#fff" strokeWidth={1} radius={[4, 4, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </>
  );
}

/**
 * Charts and insights for the leads in the selected period.
 */
export function LeadsAnalytics({ range, reloadKey }) {
  const [state, setState] = useState({ loading: true, error: null, leads: [], capped: false });

  useEffect(() => {
    let cancelled = false;
    setState((s) => ({ ...s, loading: true, error: null }));
    getLeadsForAnalytics(range)
      .then(({ docs, capped }) => !cancelled && setState({ loading: false, error: null, leads: docs, capped }))
      .catch(() => !cancelled && setState({ loading: false, error: 'فشل تحميل التحليلات', leads: [], capped: false }));
    return () => { cancelled = true; };
  }, [range, reloadKey]);

  const a = useMemo(() => analyzeLeads(state.leads, range), [state.leads, range]);

  if (state.loading && !state.leads.length) {
    return <div className="flex justify-center py-12"><Spinner size="lg" /></div>;
  }
  if (state.error) {
    return <div className="text-center py-8 text-negative text-sm">{state.error}</div>;
  }
  if (!a.total) {
    return <Card title="التحليلات"><Empty /></Card>;
  }

  return (
    <div className="space-y-4">
      {/* Insights */}
      {a.insights.length > 0 && (
        <Card title="ملاحظات" subtitle="قراءة سريعة لأرقام هذه الفترة">
          <ul className="grid gap-2 md:grid-cols-2">
            {a.insights.map((ins, i) => {
              const tone = INSIGHT_TONES[ins.tone];
              return (
                <li key={i} className={`flex items-start gap-3 rounded-xl px-4 py-3 ring-1 ring-inset ${tone.box}`}>
                  <svg className={`w-5 h-5 shrink-0 mt-0.5 ${tone.icon}`} fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.75}>
                    <path strokeLinecap="round" strokeLinejoin="round" d={tone.path} />
                  </svg>
                  <span className="text-sm text-text-primary leading-relaxed">{ins.text}</span>
                </li>
              );
            })}
          </ul>
        </Card>
      )}

      <div className="grid gap-4 lg:grid-cols-3">
        <Card
          title={a.unit === 'day' ? 'المسجلون يومياً' : 'المسجلون شهرياً'}
          subtitle="حسب المصدر"
          className="lg:col-span-2"
        >
          <Timeline points={a.points} unit={a.unit} />
        </Card>
        <Card title="الحالات" subtitle={`${a.total.toLocaleString('en-US')} مسجلاً`}>
          <BarList rows={a.status} total={a.total} dotOf={(r) => r.dot} color="#94A3B8" />
        </Card>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        <Card title="أكثر الولايات" subtitle="كل المصادر">
          <BarList rows={a.wilayas} total={a.total} />
        </Card>
        <Card title="شرائح الراتب" subtitle={`مسجلو التطبيق (${a.salaryTotal})`}>
          <BarList rows={a.salary} total={a.salaryTotal} />
        </Card>
        <Card title="الفئات العمرية" subtitle={`مسجلو التطبيق (${a.appCount})`}>
          <BarList rows={a.ages} total={a.appCount} />
        </Card>
      </div>

      <Card title="الأهداف الأكثر طلباً" subtitle="مسجلو التطبيق — يمكن اختيار أكثر من هدف">
        <BarList rows={a.goals} total={a.appCount} />
      </Card>

      {state.capped && (
        <p className="text-xs text-text-secondary text-center">التحليلات مبنية على آخر 3,000 مسجل في هذه الفترة.</p>
      )}
    </div>
  );
}
