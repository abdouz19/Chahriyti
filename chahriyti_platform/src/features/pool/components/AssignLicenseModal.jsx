import React, { useState } from 'react';
import { Modal, Input, Button } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';

/**
 * Modal for assigning a pool license to a client (pre-delivery tracking).
 */
export function AssignLicenseModal({ isOpen, onClose, license, onAssign, loading }) {
  const [clientName, setClientName] = useState('');
  const [phone, setPhone] = useState('');
  const [errors, setErrors] = useState({});

  const validate = () => {
    const errs = {};
    if (!clientName.trim()) errs.clientName = 'اسم العميل مطلوب';
    if (!phone.trim()) errs.phone = 'رقم الهاتف مطلوب';
    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validate()) return;

    const success = await onAssign({
      licenseKey: license.licenseKey,
      clientName: clientName.trim(),
      phone: phone.trim(),
    });

    if (success) {
      setClientName('');
      setPhone('');
      setErrors({});
      onClose();
    }
  };

  const handleClose = () => {
    setClientName('');
    setPhone('');
    setErrors({});
    onClose();
  };

  return (
    <Modal isOpen={isOpen} onClose={handleClose} title="تخصيص ترخيص">
      {license && (
        <form onSubmit={handleSubmit} className="space-y-4">
          {/* License key display */}
          <div className="bg-surface border border-border rounded-xl p-3 text-center">
            <p className="text-xs text-text-secondary mb-1">مفتاح الترخيص</p>
            <p className="font-mono font-bold text-primary text-lg" dir="ltr">
              {formatLicenseKey(license.licenseKey)}
            </p>
          </div>

          <Input
            label="اسم العميل"
            value={clientName}
            onChange={(e) => setClientName(e.target.value)}
            error={errors.clientName}
            placeholder="أدخل اسم العميل"
          />

          <Input
            label="رقم الهاتف"
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            error={errors.phone}
            placeholder="أدخل رقم الهاتف"
            dir="ltr"
          />

          <div className="flex gap-3 pt-2">
            <Button
              type="submit"
              variant="primary"
              fullWidth
              loading={loading}
            >
              تخصيص
            </Button>
            <Button
              type="button"
              variant="secondary"
              fullWidth
              onClick={handleClose}
            >
              إلغاء
            </Button>
          </div>
        </form>
      )}
    </Modal>
  );
}
