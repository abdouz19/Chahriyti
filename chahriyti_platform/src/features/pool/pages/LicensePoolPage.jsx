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
import { callMarkLicensesPrinted } from '../../../services/functions';
import { getUnprintedLicenses } from '../../../services/firestore';

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
    printedFilter,
    setPrintedFilter,
    deviceSearch,
    setDeviceSearch,
    hasMore,
    loadMore,
    refresh,
    poolStats,
  } = useLicensePool();

  const { loading: assigning, error: assignError, assign } = useAssignLicense();
  const { role } = useAuth();
  const navigate = useNavigate();

  const [assignTarget, setAssignTarget] = useState(null);
  const [printLicenses, setPrintLicenses] = useState(null);
  const [showPrintDialog, setShowPrintDialog] = useState(false);
  const [printCount, setPrintCount] = useState('');
  const [loadingPrint, setLoadingPrint] = useState(false);

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

  const handlePrinted = async (licenseKeys) => {
    try {
      await callMarkLicensesPrinted(licenseKeys);
      toast.success(`تم تحديث ${licenseKeys.length} ترخيص كمطبوع`);
      refresh();
    } catch {
      toast.error('فشل في تحديث حالة الطباعة');
    }
  };

  const handlePrintSubmit = async () => {
    const count = parseInt(printCount, 10);
    if (!count || count < 1) {
      toast.error('أدخل عدداً صحيحاً');
      return;
    }
    setLoadingPrint(true);
    try {
      const unprinted = await getUnprintedLicenses(count);
      if (unprinted.length === 0) {
        toast.error('لا توجد تراخيص غير مطبوعة');
        return;
      }
      if (unprinted.length < count) {
        toast(`متاح ${unprinted.length} ترخيص غير مطبوع فقط`, { icon: 'ℹ️' });
      }
      setShowPrintDialog(false);
      setPrintCount('');
      setPrintLicenses(unprinted);
    } catch {
      toast.error('فشل في تحميل التراخيص');
    } finally {
      setLoadingPrint(false);
    }
  };

  // Print view overlay
  if (printLicenses) {
    return (
      <LicensePrintView
        licenses={printLicenses}
        onClose={() => setPrintLicenses(null)}
        onPrinted={handlePrinted}
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
        <div className="flex gap-2">
          <Button
            variant="secondary"
            onClick={() => setShowPrintDialog(true)}
            icon={
              <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1.5}>
                <path strokeLinecap="round" strokeLinejoin="round" d="M6.72 13.829c-.24.03-.48.062-.72.096m.72-.096a42.415 42.415 0 0110.56 0m-10.56 0L6.34 18m10.94-4.171c.24.03.48.062.72.096m-.72-.096L17.66 18m0 0l.229 2.523a1.125 1.125 0 01-1.12 1.227H7.231c-.662 0-1.18-.568-1.12-1.227L6.34 18m11.318 0h1.091A2.25 2.25 0 0021 15.75V9.456c0-1.081-.768-2.015-1.837-2.175a48.055 48.055 0 00-1.913-.247M6.34 18H5.25A2.25 2.25 0 013 15.75V9.456c0-1.081.768-2.015 1.837-2.175a48.041 48.041 0 011.913-.247m10.5 0a48.536 48.536 0 00-10.5 0m10.5 0V3.375c0-.621-.504-1.125-1.125-1.125h-8.25c-.621 0-1.125.504-1.125 1.125v3.659M18.75 12h.008v.008h-.008V12zm-2.25 0h.008v.008H16.5V12z" />
              </svg>
            }
          >
            طباعة تراخيص
          </Button>
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
      </div>

      {/* Stats */}
      <PoolStats stats={poolStats} />

      {/* Filters */}
      <div className="flex items-center justify-between">
        <PoolFilters
          statusFilter={statusFilter}
          onStatusChange={setStatusFilter}
          printedFilter={printedFilter}
          onPrintedChange={setPrintedFilter}
          deviceSearch={deviceSearch}
          onDeviceSearchChange={setDeviceSearch}
        />
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

      {/* Print count dialog */}
      {showPrintDialog && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
          <div className="bg-card rounded-2xl shadow-xl p-6 w-full max-w-sm mx-4">
            <h3 className="text-lg font-semibold text-text-primary mb-1">طباعة تراخيص</h3>
            <p className="text-sm text-text-secondary mb-4">
              سيتم تحديد تراخيص غير مطبوعة تلقائياً (15 لكل صفحة)
            </p>
            <input
              type="number"
              min="1"
              max="10000"
              value={printCount}
              onChange={(e) => setPrintCount(e.target.value)}
              placeholder="عدد التراخيص"
              className="w-full px-4 py-2.5 border border-border rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary mb-4"
              autoFocus
              onKeyDown={(e) => e.key === 'Enter' && handlePrintSubmit()}
            />
            <div className="flex gap-2 justify-end">
              <Button
                variant="secondary"
                size="sm"
                onClick={() => { setShowPrintDialog(false); setPrintCount(''); }}
              >
                إلغاء
              </Button>
              <Button
                variant="primary"
                size="sm"
                onClick={handlePrintSubmit}
                loading={loadingPrint}
              >
                طباعة
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
