import { useState } from 'react';
import toast from 'react-hot-toast';
import { Button, Spinner, EmptyState } from '../../../components/ui';
import { ManagersTable } from '../components/ManagersTable';
import { AddManagerModal } from '../components/AddManagerModal';
import { ConfirmDeactivateModal } from '../components/ConfirmDeactivateModal';
import { useManagers } from '../hooks/useManagers';
import { STATUS } from '../../../config/constants';

/**
 * Admin page for managing manager accounts
 */
export function ManagersPage() {
  const { managers, loading, error, creating, toggling, createManager, toggleStatus, refresh } = useManagers();

  // Modal state
  const [showAddModal, setShowAddModal] = useState(false);
  const [deactivateTarget, setDeactivateTarget] = useState(null);

  /** Handle creating a new manager */
  const handleCreate = async (data) => {
    try {
      await createManager(data);
      toast.success('تم إنشاء المسؤول بنجاح');
      setShowAddModal(false);
    } catch (err) {
      toast.error(err.message || 'فشل في إنشاء المسؤول');
    }
  };

  /** Handle status toggle — show confirmation for deactivation */
  const handleToggleStatus = (uid, currentStatus, name) => {
    if (currentStatus === STATUS.ACTIVE) {
      setDeactivateTarget({ uid, name });
    } else {
      performToggle(uid, currentStatus);
    }
  };

  /** Perform the actual status toggle */
  const performToggle = async (uid, currentStatus) => {
    const newStatus = currentStatus === STATUS.ACTIVE ? STATUS.INACTIVE : STATUS.ACTIVE;
    try {
      await toggleStatus(uid, newStatus);
      toast.success(newStatus === STATUS.ACTIVE ? 'تم تفعيل المسؤول' : 'تم تعطيل المسؤول');
      setDeactivateTarget(null);
    } catch (err) {
      toast.error(err.message || 'فشل في تحديث الحالة');
    }
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <Spinner size="lg" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-semibold text-text-primary">إدارة المسؤولين</h2>
          <p className="text-sm text-text-secondary mt-0.5">
            {managers.length} مسؤول مسجل
          </p>
        </div>
        <Button
          variant="primary"
          onClick={() => setShowAddModal(true)}
          icon={
            <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
              <path strokeLinecap="round" strokeLinejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
          }
        >
          إضافة مسؤول
        </Button>
      </div>

      {/* Error banner */}
      {error && (
        <div className="bg-negative/5 border border-negative/20 rounded-xl px-4 py-3 text-sm text-negative flex items-center justify-between">
          <span>{error}</span>
          <Button variant="ghost" size="sm" onClick={refresh}>إعادة المحاولة</Button>
        </div>
      )}

      {/* Table or empty state */}
      {managers.length === 0 ? (
        <EmptyState
          icon={
            <svg className="w-12 h-12 text-text-secondary" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={1}>
              <path strokeLinecap="round" strokeLinejoin="round"
                d="M15 19.128a9.38 9.38 0 002.625.372 9.337 9.337 0 004.121-.952 4.125 4.125 0 00-7.533-2.493M15 19.128v-.003c0-1.113-.285-2.16-.786-3.07M15 19.128v.106A12.318 12.318 0 018.624 21c-2.331 0-4.512-.645-6.374-1.766l-.001-.109a6.375 6.375 0 0111.964-3.07M12 6.375a3.375 3.375 0 11-6.75 0 3.375 3.375 0 016.75 0zm8.25 2.25a2.625 2.625 0 11-5.25 0 2.625 2.625 0 015.25 0z" />
            </svg>
          }
          title="لا يوجد مسؤولين بعد"
          description="أضف أول مسؤول للبدء في توليد تراخيص العملاء"
          action={{ label: 'إضافة مسؤول', onClick: () => setShowAddModal(true) }}
        />
      ) : (
        <div className="card p-0 overflow-hidden">
          <ManagersTable
            managers={managers}
            onToggleStatus={handleToggleStatus}
            toggling={toggling}
          />
        </div>
      )}

      {/* Add Manager Modal */}
      <AddManagerModal
        isOpen={showAddModal}
        onClose={() => setShowAddModal(false)}
        onCreate={handleCreate}
        loading={creating}
      />

      {/* Confirm Deactivation Modal */}
      <ConfirmDeactivateModal
        isOpen={!!deactivateTarget}
        managerName={deactivateTarget?.name || ''}
        onConfirm={() => performToggle(deactivateTarget.uid, STATUS.ACTIVE)}
        onCancel={() => setDeactivateTarget(null)}
        loading={toggling}
      />
    </div>
  );
}
