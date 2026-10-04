import React, { useEffect } from 'react';
import { Button, Spinner, EmptyState } from '../../../components/ui';
import { LeadsTable } from '../components/LeadsTable';
import { useLeads } from '../hooks/useLeads';

export function LeadsPage() {
  const {
    leads,
    loading,
    error,
    hasMore,
    statusFilter,
    setStatusFilter,
    refresh,
    loadMore,
  } = useLeads();

  useEffect(() => { refresh(); }, [statusFilter]); // eslint-disable-line react-hooks/exhaustive-deps

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-text-primary">المسجلون</h1>
          <p className="text-text-secondary mt-1">المستخدمون الذين أكملوا تسجيل الحساب</p>
        </div>
        <Button variant="outline" onClick={refresh} disabled={loading}>
          تحديث
        </Button>
      </div>

      {/* Filter */}
      <div className="flex gap-2">
        {[
          { value: '', label: 'الكل' },
          { value: 'pending', label: 'انتظار' },
          { value: 'contacted', label: 'تم التواصل' },
          { value: 'converted', label: 'مُفعَّل' },
          { value: 'rejected', label: 'مرفوض' },
        ].map(({ value, label }) => (
          <button
            key={value}
            onClick={() => setStatusFilter(value)}
            className={`px-4 py-1.5 rounded-full text-sm font-medium transition-colors border ${
              statusFilter === value
                ? 'bg-primary text-white border-primary'
                : 'bg-white text-text-secondary border-border hover:border-primary hover:text-primary'
            }`}
          >
            {label}
          </button>
        ))}
      </div>

      {/* Content */}
      {loading && leads.length === 0 ? (
        <div className="flex justify-center py-16">
          <Spinner size="lg" />
        </div>
      ) : error ? (
        <div className="text-center py-16 text-red-500">{error}</div>
      ) : leads.length === 0 ? (
        <EmptyState
          title="لا يوجد مسجلون بعد"
          description="ستظهر هنا بيانات المستخدمين بعد إكمال التسجيل في التطبيق"
        />
      ) : (
        <>
          <LeadsTable leads={leads} onRefresh={refresh} />
          {hasMore && (
            <div className="flex justify-center pt-4">
              <Button variant="outline" onClick={loadMore} disabled={loading}>
                {loading ? <Spinner size="sm" /> : 'تحميل المزيد'}
              </Button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
