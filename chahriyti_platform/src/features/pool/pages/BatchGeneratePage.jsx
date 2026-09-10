import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button, Card, Input } from '../../../components/ui';
import { useBatchGenerate } from '../hooks/useBatchGenerate';

/**
 * Admin page for generating a batch of pool license keys.
 */
export function BatchGeneratePage() {
  const { loading, error, result, progress, generateBatch, reset } = useBatchGenerate();
  const navigate = useNavigate();
  const [count, setCount] = useState('10000');

  const handleGenerate = () => {
    const num = parseInt(count, 10);
    if (!num || num < 1 || num > 50000) return;
    generateBatch(num);
  };

  // Progress percentage
  const pct = progress.total > 0
    ? Math.round((progress.current / progress.total) * 100)
    : 0;

  return (
    <div className="max-w-lg mx-auto">
      {/* Back button */}
      <button
        onClick={() => navigate(-1)}
        className="flex items-center gap-1.5 text-sm text-text-secondary hover:text-text-primary transition-colors mb-4"
      >
        <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
          <path strokeLinecap="round" strokeLinejoin="round" d="M9 15l6-6m0 0l6 6" transform="rotate(90 12 12)" />
        </svg>
        العودة
      </button>

      <div className="mb-6">
        <h1 className="text-xl font-bold text-text-primary">توليد دفعة تراخيص</h1>
        <p className="text-sm text-text-secondary mt-1">
          توليد مفاتيح ترخيص عشوائية مشفرة وتخزينها في المجموعة
        </p>
      </div>

      <Card variant="elevated">
        {result ? (
          /* ---- Success state ---- */
          <div className="text-center">
            <div className="flex items-center justify-center mb-4">
              <div className="w-16 h-16 rounded-full bg-positive flex items-center justify-center">
                <svg className="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={3}>
                  <path strokeLinecap="round" strokeLinejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                </svg>
              </div>
            </div>
            <h3 className="text-lg font-semibold text-text-primary mb-1">
              تم التوليد بنجاح
            </h3>
            <p className="text-3xl font-bold text-primary mb-2">
              {result.totalGenerated.toLocaleString()}
            </p>
            <p className="text-sm text-text-secondary mb-6">ترخيص جديد</p>

            <div className="flex gap-3">
              <Button variant="primary" fullWidth onClick={() => navigate(-1)}>
                عرض المجموعة
              </Button>
              <Button variant="secondary" fullWidth onClick={reset}>
                توليد المزيد
              </Button>
            </div>
          </div>
        ) : (
          /* ---- Form / progress state ---- */
          <div className="space-y-5">
            <Input
              label="عدد التراخيص"
              type="number"
              value={count}
              onChange={(e) => setCount(e.target.value)}
              min={1}
              max={50000}
              disabled={loading}
              dir="ltr"
            />

            <div className="bg-surface border border-border rounded-xl p-4">
              <p className="text-xs text-text-secondary mb-2 font-medium">تفاصيل التوليد</p>
              <ul className="text-sm text-text-secondary space-y-1">
                <li>• تشفير Crockford Base32 مع checksum</li>
                <li>• صيغة: CHRY-XXXX-XXXX-XXXX-XXXX</li>
                <li>• ترخيص مدى الحياة (بدون تاريخ انتهاء)</li>
                <li>• توليد على دفعات من 1000</li>
              </ul>
            </div>

            {/* Progress bar */}
            {loading && (
              <div className="space-y-2">
                <div className="flex justify-between text-sm">
                  <span className="text-text-secondary">جاري التوليد...</span>
                  <span className="text-primary font-medium">
                    {progress.current.toLocaleString()} / {progress.total.toLocaleString()}
                  </span>
                </div>
                <div className="w-full bg-surface rounded-full h-3 overflow-hidden">
                  <div
                    className="bg-primary h-full rounded-full transition-all duration-500"
                    style={{ width: `${pct}%` }}
                  />
                </div>
                <p className="text-xs text-text-secondary text-center">{pct}%</p>
              </div>
            )}

            {/* Error */}
            {error && (
              <div className="bg-negative/5 border border-negative/20 rounded-xl px-4 py-3 text-sm text-negative">
                {error}
              </div>
            )}

            <Button
              variant="primary"
              fullWidth
              onClick={handleGenerate}
              loading={loading}
              disabled={loading || !count || parseInt(count, 10) < 1}
            >
              {loading ? `جاري التوليد... ${pct}%` : 'توليد التراخيص'}
            </Button>
          </div>
        )}
      </Card>
    </div>
  );
}
