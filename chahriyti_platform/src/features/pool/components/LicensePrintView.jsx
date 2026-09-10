import React, { useRef, useCallback } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { Button } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';

/**
 * Print-optimized view for license cards with QR codes.
 * Renders a grid of license cards (6 per A4 page).
 */
export function LicensePrintView({ licenses, onClose }) {
  const printRef = useRef(null);

  const handlePrint = useCallback(() => {
    const content = printRef.current;
    if (!content) return;

    const printWindow = window.open('', '_blank');
    printWindow.document.write(`
      <!DOCTYPE html>
      <html dir="rtl" lang="ar">
      <head>
        <meta charset="utf-8" />
        <title>تراخيص شهريتي</title>
        <style>
          * { margin: 0; padding: 0; box-sizing: border-box; }
          body { font-family: 'Segoe UI', Tahoma, sans-serif; }

          .page {
            width: 210mm;
            min-height: 297mm;
            padding: 10mm;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            grid-template-rows: repeat(3, 1fr);
            gap: 8mm;
            page-break-after: always;
          }
          .page:last-child { page-break-after: auto; }

          .card {
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            padding: 12mm 8mm;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
          }

          .brand {
            font-size: 16pt;
            font-weight: 800;
            color: #6366f1;
            letter-spacing: 2px;
            margin-bottom: 6mm;
          }

          .qr { margin-bottom: 5mm; }

          .key {
            font-family: 'Courier New', monospace;
            font-size: 13pt;
            font-weight: 700;
            letter-spacing: 1.5px;
            color: #1f2937;
            direction: ltr;
            margin-bottom: 3mm;
          }

          .footer {
            font-size: 8pt;
            color: #9ca3af;
          }

          @media print {
            body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
          }
        </style>
      </head>
      <body>${content.innerHTML}</body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
  }, []);

  // Group licenses into pages of 6
  const pages = [];
  for (let i = 0; i < licenses.length; i += 6) {
    pages.push(licenses.slice(i, i + 6));
  }

  return (
    <div className="fixed inset-0 z-50 bg-background overflow-auto">
      {/* Toolbar */}
      <div className="sticky top-0 z-10 bg-card border-b border-border px-6 py-3 flex items-center justify-between print:hidden">
        <div>
          <h2 className="text-lg font-semibold text-text-primary">معاينة الطباعة</h2>
          <p className="text-sm text-text-secondary">{licenses.length} ترخيص</p>
        </div>
        <div className="flex gap-3">
          <Button variant="primary" onClick={handlePrint}>
            طباعة
          </Button>
          <Button variant="secondary" onClick={onClose}>
            إغلاق
          </Button>
        </div>
      </div>

      {/* Print content */}
      <div ref={printRef} className="max-w-[210mm] mx-auto py-8 print:py-0">
        {pages.map((page, pageIdx) => (
          <div key={pageIdx} className="page" style={{
            width: '210mm',
            minHeight: '297mm',
            padding: '10mm',
            display: 'grid',
            gridTemplateColumns: 'repeat(2, 1fr)',
            gridTemplateRows: 'repeat(3, 1fr)',
            gap: '8mm',
            pageBreakAfter: pageIdx < pages.length - 1 ? 'always' : 'auto',
          }}>
            {page.map((license) => (
              <div
                key={license.id}
                style={{
                  border: '2px solid #e5e7eb',
                  borderRadius: '12px',
                  padding: '12mm 8mm',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  textAlign: 'center',
                }}
              >
                <div style={{ fontSize: '16pt', fontWeight: 800, color: '#6366f1', letterSpacing: '2px', marginBottom: '6mm' }}>
                  CHAHRIYTI
                </div>
                <div style={{ marginBottom: '5mm' }}>
                  <QRCodeSVG
                    value={license.licenseKey}
                    size={120}
                    level="M"
                  />
                </div>
                <div style={{
                  fontFamily: "'Courier New', monospace",
                  fontSize: '13pt',
                  fontWeight: 700,
                  letterSpacing: '1.5px',
                  color: '#1f2937',
                  direction: 'ltr',
                  marginBottom: '3mm',
                }}>
                  {formatLicenseKey(license.licenseKey)}
                </div>
                <div style={{ fontSize: '8pt', color: '#9ca3af' }}>
                  امسح الرمز أو أدخل المفتاح في التطبيق
                </div>
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
