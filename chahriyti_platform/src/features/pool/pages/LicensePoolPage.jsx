import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import toast from 'react-hot-toast';
import { Button, Spinner, EmptyState } from '../../../components/ui';
import { PoolStats } from '../components/PoolStats';
import { PoolFilters } from '../components/PoolFilters';
import { PoolTable } from '../components/PoolTable';
import { AssignLicenseModal } from '../components/AssignLicenseModal';
import { LicensePrintView } from '../components/LicensePrintView';
import { useLicensePool } from '../hooks/useLicensePool';
import { useAssignLicense } from '../hooks/useAssignLicense';
import { useAuth } from '../../../hooks/useAuth';

/**
 * Main pool management page — view, filter, assign, and print licenses.
 */
export function LicensePoolPage() {
  const {
    licenses,
    loading,
    error,
    statusFilter,
    setStatusFilter,
    hasMore,
    loadMore,
    refresh,
    poolStats,
  } = useLicensePool();

  const { loading: assigning, error: assignError, assign } = useAssignLicense();
  const { role } = useAuth();
  const navigate = useNavigate();

  // Modal / print state
  const [assignTarget, setAssignTarget] = useState(null);
  const [printLicenses, setPrintLicenses] = useState(null);

  const handleAssign = async (data) => {
    const success = await assign(data);
    if (success) {
      toast.success('تم تخصيص الترخيص بنجاح');
      refresh();
      return true;
    } else {
      toast.error(assignError || 'فشل في تخصيص الترخيص');
      return false;
    }
  };

  // Print view overlay
  if (printLicenses) {
    return (
      <LicensePrintView
        licenses={printLicenses}
        onClose={() => setPrintLicenses(null)}
      />
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-semibold text-text-primary">مجموعة التراخيص</h2>
          <p className="text-sm text-text-secondary mt-0.5">
            إدارة التراخيص المولدة مسبقاً
          </p>
        </div>
        {role === 'admin' && (
          <Button
            variant="primary"
            onClick={() => navigate('generate')}
            icon={
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
            }
          >
            توليد دفعة جديدة
          </Button>
        )}
      </div>

      {/* Stats */}
      <PoolStats stats={poolStats} />

      {/* Filters */}
      <div className="flex items-center justify-between">
        <PoolFilters statusFilter={statusFilter} onStatusChange={setStatusFilter} />
        <Button variant="ghost" size="sm" onClick={refresh}>
          تحديث
        </Button>
      </div>

      {/* Error */}
      {error && (
        <div className="bg-negative/5 border border-negative/20 rounded-xl px-4 py-3 text-sm text-negative flex items-center justify-between">
          <span>{error}</span>
          <Button variant="ghost" size="sm" onClick={refresh}>إعادة المحاولة</Button>
        </div>
      )}

      {/* Loading */}
      {loading && licenses.length === 0 ? (
        <div className="flex items-center justify-center min-h-[300px]">
          <Spinner size="lg" />
        </div>
      ) : licenses.length === 0 ? (
        <EmptyState
          icon={
            <svg className="w-12 h-12 text-text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M15.75 5.25a3 3 0 013 3m3 0a6 6 0 01-7.029 5.912c-.563-.097-1.159.026-1.563.43L10.5 17.25H8.25v2.25H6v2.25H2.25v-2.818c0-.597.237-1.17.659-1.591l6.499-6.499c.404-.404.527-1 .43-1.563A6 6 0 1121.75 8.25z" />
            </svg>
          }
          title="لا توجد تراخيص بعد"
          description="ولّد دفعة جديدة من التراخيص للبدء"
          action={role === 'admin' ? { label: 'توليد دفعة', onClick: () => navigate('generate') } : undefined}
        />
      ) : (
        <>
          <div className="card p-0 overflow-hidden">
            <PoolTable
              licenses={licenses}
              onAssign={setAssignTarget}
              onPrint={setPrintLicenses}
              loading={loading}
            />
          </div>

          {/* Load more */}
          {hasMore && (
            <div className="text-center">
              <Button variant="secondary" onClick={loadMore} loading={loading}>
                تحميل المزيد
              </Button>
            </div>
          )}
        </>
      )}

      {/* Assign modal */}
      <AssignLicenseModal
        isOpen={!!assignTarget}
        onClose={() => setAssignTarget(null)}
        license={assignTarget}
        onAssign={handleAssign}
        loading={assigning}
      />
    </div>
  );
}
