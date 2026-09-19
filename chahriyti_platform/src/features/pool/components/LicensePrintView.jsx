import React, { useRef, useCallback } from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { Button } from '../../../components/ui';
import { formatLicenseKey } from '../../../utils/formatters';

const LOGO_DATA_URI =
  'data:image/png;base64,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';

const CARDS_PER_PAGE = 15;

const PRINT_STYLES = `
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Segoe UI', Tahoma, sans-serif; direction: rtl; }

  @page { size: A4; margin: 5mm; }

  .page {
    width: 200mm;
    height: 287mm;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: repeat(5, 1fr);
    gap: 3mm;
    page-break-after: always;
  }
  .page:last-child { page-break-after: auto; }

  .card {
    border: 1px solid #d1d5db;
    border-radius: 6px;
    display: flex;
    flex-direction: row;
    overflow: hidden;
    direction: rtl;
  }

  /* Right edge teal stripe */
  .card-stripe {
    width: 4mm;
    min-width: 4mm;
    background: #0D7377;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }
  .card-stripe span {
    writing-mode: vertical-rl;
    text-orientation: mixed;
    transform: rotate(180deg);
    color: #fff;
    font-size: 5pt;
    font-weight: 700;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    white-space: nowrap;
  }

  /* Right section - branding & text */
  .card-info {
    flex: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 2mm 2.5mm;
    min-width: 0;
  }

  .card-logo-row {
    display: flex;
    align-items: center;
    gap: 2px;
    margin-bottom: 1.5mm;
  }
  .card-logo-row img {
    width: 14px;
    height: 14px;
    object-fit: contain;
  }
  .card-logo-row span {
    font-size: 6pt;
    font-weight: 700;
    color: #0D7377;
  }

  .card-title {
    font-size: 7.5pt;
    font-weight: 800;
    color: #0D7377;
    line-height: 1.3;
    margin-bottom: 1mm;
  }

  .card-subtitle {
    font-size: 5.5pt;
    color: #6b7280;
    line-height: 1.3;
    margin-bottom: 1.5mm;
  }

  .card-badge {
    display: inline-block;
    font-size: 5pt;
    color: #0D7377;
    border: 0.5px solid #0D7377;
    border-radius: 8px;
    padding: 0.3mm 2mm;
    white-space: nowrap;
    align-self: flex-start;
  }

  /* Left section - QR */
  .card-qr {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 2mm;
    flex-shrink: 0;
  }

  .card-key {
    font-family: 'Courier New', monospace;
    font-size: 5pt;
    color: #1f2937;
    direction: ltr;
    text-align: center;
    margin-top: 1mm;
    word-break: break-all;
  }

  @media print {
    body { -webkit-print-color-adjust: exact; print-color-adjust: exact; }
  }
`;

/**
 * Print-optimized view for license cards with QR codes.
 * Renders a grid of 15 license cards per A4 page (3 columns x 5 rows).
 */
export function LicensePrintView({ licenses, onClose, onPrinted }) {
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
        <style>${PRINT_STYLES}</style>
      </head>
      <body>${content.innerHTML}</body>
      </html>
    `);
    printWindow.document.close();
    printWindow.focus();

    // Wait for content to load then trigger print
    printWindow.onload = () => {
      printWindow.print();
      if (onPrinted) {
        onPrinted(licenses.map((l) => l.licenseKey));
      }
    };

    // Fallback if onload doesn't fire (some browsers)
    setTimeout(() => {
      try {
        printWindow.print();
      } catch (_) {
        // already printed
      }
      if (onPrinted) {
        onPrinted(licenses.map((l) => l.licenseKey));
      }
    }, 500);
  }, [licenses, onPrinted]);

  // Group licenses into pages of 15
  const pages = [];
  for (let i = 0; i < licenses.length; i += CARDS_PER_PAGE) {
    pages.push(licenses.slice(i, i + CARDS_PER_PAGE));
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

      {/* Inline preview + print content */}
      <div ref={printRef} className="max-w-[210mm] mx-auto py-8 print:py-0">
        {pages.map((page, pageIdx) => (
          <div
            key={pageIdx}
            style={{
              width: '200mm',
              height: '287mm',
              display: 'grid',
              gridTemplateColumns: 'repeat(3, 1fr)',
              gridTemplateRows: 'repeat(5, 1fr)',
              gap: '3mm',
              pageBreakAfter: pageIdx < pages.length - 1 ? 'always' : 'auto',
              margin: '0 auto',
              marginBottom: pageIdx < pages.length - 1 ? '10mm' : '0',
            }}
          >
            {page.map((license) => (
              <div
                key={license.id}
                style={{
                  border: '1px solid #d1d5db',
                  borderRadius: '6px',
                  display: 'flex',
                  flexDirection: 'row',
                  overflow: 'hidden',
                  direction: 'rtl',
                }}
              >
                {/* Right edge teal stripe */}
                <div
                  style={{
                    width: '4mm',
                    minWidth: '4mm',
                    background: '#0D7377',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    flexShrink: 0,
                  }}
                >
                  <span
                    style={{
                      writingMode: 'vertical-rl',
                      textOrientation: 'mixed',
                      transform: 'rotate(180deg)',
                      color: '#fff',
                      fontSize: '5pt',
                      fontWeight: 700,
                      letterSpacing: '1.5px',
                      textTransform: 'uppercase',
                      whiteSpace: 'nowrap',
                    }}
                  >
                    SHAHRIYTI
                  </span>
                </div>

                {/* Right section - branding & text */}
                <div
                  style={{
                    flex: 1,
                    display: 'flex',
                    flexDirection: 'column',
                    justifyContent: 'center',
                    padding: '2mm 2.5mm',
                    minWidth: 0,
                  }}
                >
                  <div
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      gap: '2px',
                      marginBottom: '1.5mm',
                    }}
                  >
                    <img
                      src={LOGO_DATA_URI}
                      alt=""
                      style={{ width: '14px', height: '14px', objectFit: 'contain' }}
                    />
                    <span style={{ fontSize: '6pt', fontWeight: 700, color: '#0D7377' }}>
                      شهريتي
                    </span>
                  </div>
                  <div
                    style={{
                      fontSize: '7.5pt',
                      fontWeight: 800,
                      color: '#0D7377',
                      lineHeight: 1.3,
                      marginBottom: '1mm',
                    }}
                  >
                    كود تفعيل تطبيق
                    <br />
                    شهريتي
                  </div>
                  <div
                    style={{
                      fontSize: '5.5pt',
                      color: '#6b7280',
                      lineHeight: 1.3,
                      marginBottom: '1.5mm',
                    }}
                  >
                    امسح الرمز
                    <br />
                    لتفعيل التطبيق
                  </div>
                  <span
                    style={{
                      display: 'inline-block',
                      fontSize: '5pt',
                      color: '#0D7377',
                      border: '0.5px solid #0D7377',
                      borderRadius: '8px',
                      padding: '0.3mm 2mm',
                      whiteSpace: 'nowrap',
                      alignSelf: 'flex-start',
                    }}
                  >
                    صالح مرة واحدة
                  </span>
                </div>

                {/* Left section - QR code */}
                <div
                  style={{
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '2mm',
                    flexShrink: 0,
                  }}
                >
                  <QRCodeSVG
                    value={license.licenseKey}
                    size={80}
                    level="M"
                    fgColor="#0D7377"
                  />
                  <div
                    style={{
                      fontFamily: "'Courier New', monospace",
                      fontSize: '5pt',
                      color: '#1f2937',
                      direction: 'ltr',
                      textAlign: 'center',
                      marginTop: '1mm',
                      wordBreak: 'break-all',
                    }}
                  >
                    {formatLicenseKey(license.licenseKey)}
                  </div>
                </div>
              </div>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
}
