import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { Button, Spinner, EmptyState, Input } from '../../../components/ui';
import { LeadsTable } from '../components/LeadsTable';
import { LeadsStats } from '../components/LeadsStats';
import { PeriodFilter, periodToRange } from '../components/PeriodFilter';
import { LeadsAnalytics } from '../components/LeadsAnalytics';
import { getLeadsStats } from '../../../services/firestore';
import { useLeads } from '../hooks/useLeads';
import { LEAD_STATUSES } from '../leadStatus';

const VIEW_KEY = 'leads.view';

function readView() {
  try { return localStorage.getItem(VIEW_KEY) === 'analytics' ? 'analytics' : 'list'; } catch { return 'list'; }
}

export function LeadsPage() {
  const [period, setPeriod] = useState({ preset: 'all', customFrom: '', customTo: '' });
  const range = useMemo(() => periodToRange(period), [period]);
  const {
    leads,
    loading,
    error,
    hasMore,
    statusFilter,
    setStatusFilter,
    phoneQuery,
    setPhoneQuery,
    refresh,
    loadMore,
  } = useLeads(range);
  const [phoneInput, setPhoneInput] = useState('');
  const [stats, setStats] = useState(null);
  const [view, setView] = useState(readView);
  const [reloadKey, setReloadKey] = useState(0);

  const changeView = (v) => {
    setView(v);
    try { localStorage.setItem(VIEW_KEY, v); } catch { /* private mode: not remembered */ }
  };

  const loadStats = useCallback(async () => {
    try {
      setStats(await getLeadsStats(range));
    } catch (e) {
      console.error('Lead stats failed:', e);
    }
  }, [range]);

  // New period: blank the cards so old numbers aren't read as the new period's
  useEffect(() => { setStats(null); loadStats(); }, [loadStats]);

  // Reload the list and the counts together (e.g. after a status change)
  const refreshAll = useCallback(() => {
    refresh();
    loadStats();
    setReloadKey((k) => k + 1);
  }, [refresh, loadStats]);

  // Search once typing pauses; digits only, matched as a phone prefix
  useEffect(() => {
    const t = setTimeout(() => setPhoneQuery(phoneInput.replace(/\D/g, '')), 350);
    return () => clearTimeout(t);
  }, [phoneInput, setPhoneQuery]);

  useEffect(() => { refresh(); }, [statusFilter, phoneQuery, range]); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-text-primary">المسجلون</h1>
          <p className="text-text-secondary mt-1">المستخدمون الذين أكملوا تسجيل الحساب</p>
        </div>
        <Button variant="secondary" onClick={refreshAll} disabled={loading}>
          تحديث
        </Button>
      </div>

      <PeriodFilter value={period} onChange={setPeriod} />

      <LeadsStats stats={stats} />

      {/* List / analytics switch */}
      <div className="inline-flex p-1 rounded-xl bg-surface border border-border">
        {[['list', 'القائمة'], ['analytics', 'التحليلات']].map(([v, label]) => (
          <button
            key={v}
            onClick={() => changeView(v)}
            className={`px-4 py-1.5 rounded-lg text-sm font-medium transition-all ${
              view === v ? 'bg-white text-text-primary shadow-card' : 'text-text-secondary hover:text-text-primary'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {view === 'analytics' ? (
        <LeadsAnalytics range={range} reloadKey={reloadKey} />
      ) : (
      <>
      {/* Search + filter */}
      <div className="flex flex-wrap items-center gap-3">
        <Input
          type="search"
          inputMode="numeric"
          placeholder="ابحث برقم الهاتف..."
          value={phoneInput}
          onChange={(e) => setPhoneInput(e.target.value)}
          className="w-full sm:w-72"
        />
        <div className="flex flex-wrap gap-2">
          {[
            { value: '', label: 'الكل' },
            ...Object.entries(LEAD_STATUSES).map(([value, s]) => ({ value, ...s })),
          ].map(({ value, label, dot }) => {
            const active = statusFilter === value;
            const count = stats ? (value ? stats.byStatus[value] : stats.total) : null;
            return (
            <button
              key={value}
              onClick={() => setStatusFilter(value)}
              className={`inline-flex items-center gap-2 px-4 py-1.5 rounded-full text-sm font-medium transition-colors border ${
                active
                  ? 'bg-primary text-white border-primary'
                  : 'bg-white text-text-secondary border-border hover:border-primary hover:text-primary'
              }`}
            >
              {dot && <span className={`w-2 h-2 rounded-full ${dot}`} />}
              {label}
              {count !== null && (
                <span className={`min-w-[1.5rem] px-1.5 py-0.5 rounded-full text-xs font-semibold tabular-nums ${
                  active ? 'bg-white/20 text-white' : 'bg-surface text-text-secondary'
                }`}>
                  {count.toLocaleString('en-US')}
                </span>
              )}
            </button>
            );
          })}
        </div>
      </div>

      {/* Content */}
      {loading && leads.length === 0 ? (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      ) : error ? (
        <div className="text-center py-16 text-red-500">{error}</div>
      ) : leads.length === 0 ? (
        phoneQuery ? (
          <EmptyState
            title="لا توجد نتائج"
            description={`لا يوجد مسجل برقم يبدأ بـ ${phoneQuery}`}
          />
        ) : (
          <EmptyState
            title="لا يوجد مسجلون بعد"
            description="ستظهر هنا بيانات المستخدمين بعد إكمال التسجيل في التطبيق"
          />
        )
      ) : (
        <>
          <LeadsTable leads={leads} onRefresh={refreshAll} />
          {hasMore && (
            <div className="flex justify-center pt-4">
              <Button variant="secondary" onClick={loadMore} disabled={loading}>
                {loading ? <Spinner size="sm" /> : 'تحميل المزيد'}
              </Button>
            </div>
          )}
        </>
      )}
      </>
      )}
    </div>
  );
}
