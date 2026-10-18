import React from 'react';

const ICONS = {
  total: 'M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z',
  app: 'M10.5 1.5H8.25A2.25 2.25 0 006 3.75v16.5a2.25 2.25 0 002.25 2.25h7.5A2.25 2.25 0 0018 20.25V3.75a2.25 2.25 0 00-2.25-2.25H13.5m-3 0V3h3V1.5m-3 0h3m-3 18.75h3',
  store: 'M2.25 3h1.386c.51 0 .955.343 1.087.835l.383 1.437M7.5 14.25a3 3 0 00-3 3h15.75m-12.75-3h11.218c1.121-2.3 2.1-4.684 2.924-7.138a60.114 60.114 0 00-16.536-1.84M7.5 14.25L5.106 5.272M6 20.25a.75.75 0 11-1.5 0 .75.75 0 011.5 0zm12.75 0a.75.75 0 11-1.5 0 .75.75 0 011.5 0z',
  converted: 'M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
};

function pct(part, total) {
  return total ? Math.round((part / total) * 100) : 0;
}

function StatCard({ icon, tone, label, value, hint }) {
  return (
    <div className="bg-card border border-border rounded-2xl p-5 shadow-card">
      <div className="flex items-center justify-between">
        <span className="text-sm font-medium text-text-secondary">{label}</span>
        <span className={`w-9 h-9 rounded-xl flex items-center justify-center ${tone}`}>
          <svg className="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.75}>
            <path strokeLinecap="round" strokeLinejoin="round" d={ICONS[icon]} />
          </svg>
        </span>
      </div>
      <p className="mt-3 text-3xl font-bold text-text-primary tabular-nums">
        {value === null ? <span className="inline-block w-16 h-8 rounded-lg bg-divider animate-pulse" /> : value.toLocaleString('en-US')}
      </p>
      <p className="mt-2 text-xs text-text-secondary min-h-[1rem]">{hint}</p>
    </div>
  );
}

/**
 * Lead counts: total (and today), by source, and how many activated.
 */
export function LeadsStats({ stats }) {
  const s = stats ?? {};
  const loaded = !!stats;

  return (
    <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
      <StatCard
        icon="total"
        tone="text-primary bg-primary/10"
        label="إجمالي المسجلين"
        value={loaded ? s.total : null}
        hint={loaded ? `+${s.today} اليوم` : ''}
      />
      <StatCard
        icon="app"
        tone="text-blue-600 bg-blue-50"
        label="من التطبيق"
        value={loaded ? s.app : null}
        hint={loaded ? `${pct(s.app, s.total)}% من الإجمالي` : ''}
      />
      <StatCard
        icon="store"
        tone="text-orange-600 bg-orange-50"
        label="من المتجر"
        value={loaded ? s.store : null}
        hint={loaded ? `${pct(s.store, s.total)}% من الإجمالي` : ''}
      />
      <StatCard
        icon="converted"
        tone="text-emerald-600 bg-emerald-50"
        label="مُفعَّل"
        value={loaded ? s.byStatus.converted : null}
        hint={loaded ? `نسبة التفعيل ${pct(s.byStatus.converted, s.total)}%` : ''}
      />
    </div>
  );
}
