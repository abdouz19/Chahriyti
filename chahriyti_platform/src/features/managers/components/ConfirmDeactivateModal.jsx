import { Modal, Button } from '../../../components/ui';

/**
 * Confirmation dialog for deactivating a manager account.
 *
 * @param {Object} props
 * @param {boolean} props.isOpen - Controls modal visibility
 * @param {string} props.managerName - Name of the manager being deactivated
 * @param {Function} props.onConfirm - Called when the user confirms deactivation
 * @param {Function} props.onCancel - Called when the user cancels
 * @param {boolean} props.loading - Whether the deactivation request is in progress
 */
export function ConfirmDeactivateModal({
  isOpen,
  managerName,
  onConfirm,
  onCancel,
  loading,
}) {
  return (
    <Modal isOpen={isOpen} onClose={onCancel} title="تأكيد تعطيل الحساب" size="sm">
      <div className="space-y-4">
        {/* Warning icon + message */}
        <div className="flex flex-col items-center text-center gap-3">
          <div className="w-12 h-12 rounded-full bg-negative/10 flex items-center justify-center">
            <svg
              className="w-6 h-6 text-negative"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              strokeWidth={1.5}
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
              />
            </svg>
          </div>

          <div>
            <p className="text-sm text-text-primary font-medium mb-1">
              هل أنت متأكد من تعطيل حساب
            </p>
            <p className="text-base font-semibold text-text-primary">
              {managerName}
            </p>
          </div>

          <p className="text-sm text-text-secondary">
            سيتم إلغاء صلاحية الوصول لهذا المدير فوراً ولن يتمكن من تسجيل الدخول.
          </p>
        </div>

        {/* Actions */}
        <div className="flex items-center gap-3 pt-1">
          <Button
            variant="danger"
            onClick={onConfirm}
            loading={loading}
            fullWidth
          >
            تعطيل الحساب
          </Button>
          <Button
            variant="secondary"
            onClick={onCancel}
            disabled={loading}
            fullWidth
          >
            إلغاء
          </Button>
        </div>
      </div>
    </Modal>
  );
}
