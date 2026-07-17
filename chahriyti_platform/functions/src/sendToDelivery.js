const { onCall, HttpsError } = require('firebase-functions/v2/https');
const admin = require('firebase-admin');
const nodemailer = require('nodemailer');
const PDFDocument = require('pdfkit');
const QRCode = require('qrcode');
const opentype = require('opentype.js');
const ArabicReshaper = require('arabic-reshaper');
const fs = require('fs');
const path = require('path');
const { verifyRole } = require('./middleware');

if (!admin.apps.length) admin.initializeApp();

const DELIVERY_EMAIL = 'mohamedabderraouf.zouaid.lp1@gmail.com';

const BRAND = {
  primary: '#0D6E6E',
  primaryDark: '#095555',
  primaryLight: '#E6F5F5',
  accent: '#14B8A6',
  text: '#1A1A2E',
  textSecondary: '#64748B',
  border: '#E2E8F0',
  danger: '#EF4444',
  dangerBg: '#FEF2F2',
  dangerText: '#991B1B',
  warningBg: '#FFFBEB',
  warningText: '#92400E',
};

// Font paths
const FONT_REGULAR = path.join(__dirname, 'fonts', 'Amiri-Regular.ttf');
const FONT_BOLD = path.join(__dirname, 'fonts', 'Amiri-Bold.ttf');

// Lazy-loaded opentype.js fonts for Arabic path rendering
let _otRegular, _otBold;
function otFont(style) {
  if (style === 'bold') {
    if (!_otBold) _otBold = opentype.parse(fs.readFileSync(FONT_BOLD).buffer);
    return _otBold;
  }
  if (!_otRegular) _otRegular = opentype.parse(fs.readFileSync(FONT_REGULAR).buffer);
  return _otRegular;
}

function formatKey(key) {
  if (!key) return '';
  const clean = key.replace(/-/g, '');
  return clean.match(/.{1,4}/g)?.join('-') || key;
}

/**
 * Render Arabic text as SVG paths in PDFKit with proper RTL layout.
 *
 * 1. arabic-reshaper converts characters to Arabic Presentation Forms
 *    (correct initial/medial/final joining — no font GSUB needed)
 * 2. String reversed for RTL visual order
 * 3. opentype.js charToGlyph does simple cmap lookup (bypasses GSUB)
 * 4. Glyph paths drawn directly via PDFKit
 */
function drawArabic(doc, text, x, y, fontSize, options = {}) {
  if (!text) return;
  const { align = 'left', width = 0, color = '#000000', fontStyle = 'regular' } = options;
  const font = otFont(fontStyle);
  const scale = fontSize / font.unitsPerEm;
  const baselineY = y + font.ascender * scale;

  // Reshape: convert to Arabic Presentation Forms (joined letter shapes)
  let reshaped;
  try {
    reshaped = ArabicReshaper.convertArabic(text);
  } catch {
    reshaped = text;
  }

  // Reverse for RTL visual display
  const visual = Array.from(reshaped).reverse().join('');

  // Get individual glyph outlines via cmap (no GSUB processing)
  const glyphData = [];
  let totalAdvance = 0;
  for (const char of Array.from(visual)) {
    const glyph = font.charToGlyph(char);
    const adv = (glyph.advanceWidth || 0) * scale;
    glyphData.push({ glyph, xPos: totalAdvance, advance: adv });
    totalAdvance += adv;
  }

  if (glyphData.length === 0) return;

  // Alignment offset
  let offsetX = x;
  if (align === 'center' && width) {
    offsetX = x + (width - totalAdvance) / 2;
  } else if (align === 'right' && width) {
    offsetX = x + width - totalAdvance;
  }

  // Draw each glyph path
  doc.save();
  doc.fillColor(color);
  for (const { glyph, xPos } of glyphData) {
    const p = glyph.getPath(offsetX + xPos, baselineY, fontSize);
    const d = p.toPathData(2);
    if (d) doc.path(d).fill();
  }
  doc.restore();
}

async function generateQRBuffer(text, size = 160) {
  return QRCode.toBuffer(text, {
    width: size,
    margin: 1,
    color: { dark: BRAND.primary, light: '#FFFFFF' },
    errorCorrectionLevel: 'H',
  });
}

/**
 * Generate branded Arabic PDF with QR code.
 */
async function generatePDF({ clientName, phone, deviceId, licenseKey, expiryDate, managerName, generatedAt }) {
  const formattedKey = formatKey(licenseKey);
  const formattedExpiry = expiryDate ? `${expiryDate.slice(4, 6)} / ${expiryDate.slice(0, 4)}` : 'N/A';
  const formattedDate = generatedAt
    ? new Date(generatedAt).toLocaleDateString('en-GB')
    : new Date().toLocaleDateString('en-GB');

  const qrBuffer = await generateQRBuffer(licenseKey, 140);

  return new Promise((resolve, reject) => {
    const doc = new PDFDocument({ size: 'A4', margin: 0 });
    const chunks = [];
    doc.on('data', (c) => chunks.push(c));
    doc.on('end', () => resolve(Buffer.concat(chunks)));
    doc.on('error', reject);

    // Register Arabic fonts (used only for PDFKit fallback on LTR text)
    doc.registerFont('Arabic', FONT_REGULAR);
    doc.registerFont('Arabic-Bold', FONT_BOLD);

    const W = doc.page.width; // 595
    const H = doc.page.height; // 842
    const M = 50;
    const contentW = W - M * 2;

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // HEADER
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    doc.rect(0, 0, W, 130).fill(BRAND.primary);
    doc.rect(0, 120, W, 10).fill(BRAND.primaryDark);
    doc.rect(0, 130, W, 4).fill(BRAND.accent);

    // Logo letter
    doc.circle(W / 2, 42, 22).fill('rgba(255,255,255,0.15)');
    drawArabic(doc, 'ش', W / 2 - 22, 22, 20, { width: 44, align: 'center', color: '#FFFFFF', fontStyle: 'bold' });

    // Title
    drawArabic(doc, 'شهريتي', M, 62, 26, { width: contentW, align: 'center', color: '#FFFFFF', fontStyle: 'bold' });
    drawArabic(doc, 'شهادة ترخيص', M, 94, 11, { width: contentW, align: 'center', color: 'rgba(255,255,255,0.7)' });

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // LICENSE KEY CARD
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const cardY = 154;
    const cardH = 85;
    doc.roundedRect(M, cardY, contentW, cardH, 12).fill(BRAND.primaryLight);
    doc.roundedRect(M, cardY, contentW, cardH, 12).strokeColor(BRAND.primary).lineWidth(1.5).stroke();

    drawArabic(doc, 'مفتاح الترخيص', M, cardY + 12, 10, { width: contentW, align: 'center', color: BRAND.textSecondary });

    // Key value (LTR, monospace — use standard doc.text)
    doc.font('Courier-Bold').fontSize(22).fillColor(BRAND.primary);
    doc.text(formattedKey, M, cardY + 38, { width: contentW, align: 'center' });

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // PAYMENT WARNING
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const warnY = cardY + cardH + 20;
    const warnH = 52;
    doc.roundedRect(M, warnY, contentW, warnH, 10).fill(BRAND.dangerBg);
    doc.roundedRect(M, warnY, contentW, warnH, 10).strokeColor(BRAND.danger).lineWidth(0.8).stroke();

    doc.fontSize(16).fillColor(BRAND.dangerText);
    doc.text('⚠', M, warnY + 6, { width: contentW, align: 'center' });

    drawArabic(doc, 'لا يتم تسليم مفتاح الترخيص للعميل قبل إتمام عملية الدفع', M + 16, warnY + 26, 11, {
      width: contentW - 32, align: 'center', color: BRAND.dangerText, fontStyle: 'bold',
    });

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // DETAILS TABLE + QR CODE
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const sectionY = warnY + warnH + 24;
    const qrSize = 120;
    const qrX = M + 15;
    const qrY = sectionY + 10;

    // QR Code on the left
    doc.image(qrBuffer, qrX, qrY, { width: qrSize, height: qrSize });
    drawArabic(doc, 'امسح لنسخ المفتاح', qrX, qrY + qrSize + 6, 7, { width: qrSize, align: 'center', color: BRAND.textSecondary });

    // Details on the right
    const tableX = qrX + qrSize + 30;
    const tableW = W - M - tableX;

    // Section header
    drawArabic(doc, 'تفاصيل الترخيص', tableX, sectionY, 12, { width: tableW, align: 'right', color: BRAND.text, fontStyle: 'bold' });

    const divLineY = sectionY + 22;
    doc.moveTo(tableX, divLineY).lineTo(tableX + tableW, divLineY).strokeColor(BRAND.accent).lineWidth(2).stroke();

    // Table rows
    const labels = ['اسم العميل', 'رقم الهاتف', 'رقم الجهاز', 'تاريخ الانتهاء', 'المسؤول', 'تاريخ التوليد'];
    const values = [clientName, phone, deviceId, formattedExpiry, managerName || 'N/A', formattedDate];
    const rowH = 26;
    let y = divLineY + 12;

    labels.forEach((label, i) => {
      if (i % 2 === 0) {
        doc.rect(tableX - 4, y - 3, tableW + 8, rowH).fill('#F8FAFB');
      }
      // Arabic label (right aligned)
      drawArabic(doc, label, tableX, y + 3, 9, { width: tableW, align: 'right', color: BRAND.textSecondary });

      // Value (left aligned, LTR)
      doc.font('Arabic-Bold').fontSize(10).fillColor(BRAND.text);
      doc.text(values[i] || 'N/A', tableX, y + 4, { width: tableW * 0.6 });

      y += rowH;
    });

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // BOTTOM NOTE
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const noteY = Math.max(y + 24, qrY + qrSize + 40);
    doc.roundedRect(M, noteY, contentW, 40, 8).fill(BRAND.warningBg);
    doc.roundedRect(M, noteY, contentW, 40, 8).strokeColor('#FDE68A').lineWidth(0.5).stroke();
    drawArabic(doc, 'يرجى تسليم الترخيص للعميل في أقرب وقت ممكن بعد تأكيد الدفع', M + 12, noteY + 11, 9, {
      width: contentW - 24, align: 'center', color: BRAND.warningText,
    });

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // FOOTER
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    const footY = H - 40;
    doc.moveTo(M, footY - 8).lineTo(W - M, footY - 8).strokeColor(BRAND.border).lineWidth(0.5).stroke();
    doc.font('Arabic').fontSize(7).fillColor(BRAND.textSecondary);
    doc.text(`chahriyati.web.app  |  ${formattedDate}`, M, footY, { width: contentW, align: 'center' });

    doc.end();
  });
}

/**
 * Build branded Arabic HTML email with QR as CID inline image.
 */
function buildEmailHTML({ clientName, phone, deviceId, licenseKey, expiryDate, managerName, generatedAt }) {
  const formattedKey = formatKey(licenseKey);
  const formattedExpiry = expiryDate ? `${expiryDate.slice(4, 6)} / ${expiryDate.slice(0, 4)}` : 'غير محدد';
  const formattedDate = generatedAt
    ? new Date(generatedAt).toLocaleDateString('ar-DZ', { year: 'numeric', month: 'long', day: 'numeric' })
    : new Date().toLocaleDateString('ar-DZ', { year: 'numeric', month: 'long', day: 'numeric' });

  return `<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;padding:0;background-color:#F1F5F9;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#F1F5F9;padding:40px 20px;">
    <tr><td align="center">
      <table width="600" cellpadding="0" cellspacing="0" style="background:#FFFFFF;border-radius:20px;overflow:hidden;box-shadow:0 20px 60px rgba(13,110,110,0.12);">

        <!-- Header -->
        <tr><td style="background:${BRAND.primary};padding:36px 40px;text-align:center;">
          <div style="width:56px;height:56px;background:rgba(255,255,255,0.15);border-radius:14px;margin:0 auto 14px;line-height:56px;font-size:24px;color:#fff;font-weight:800;">ش</div>
          <h1 style="margin:0;color:#FFFFFF;font-size:24px;font-weight:800;">شهريتي</h1>
          <p style="margin:8px 0 0;color:rgba(255,255,255,0.7);font-size:12px;">ترخيص جديد تم توليده</p>
        </td></tr>
        <tr><td style="height:4px;background:${BRAND.accent};"></td></tr>

        <!-- Body -->
        <tr><td style="padding:32px 36px;">

          <!-- Payment Warning -->
          <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
            <tr><td style="background:${BRAND.dangerBg};border:1px solid #FECACA;border-radius:14px;padding:20px;text-align:center;">
              <p style="margin:0 0 4px;font-size:26px;">&#9888;&#65039;</p>
              <p style="margin:0 0 4px;color:${BRAND.dangerText};font-size:15px;font-weight:700;">لا يتم تسليم الترخيص قبل إتمام الدفع</p>
              <p style="margin:0;color:${BRAND.dangerText};font-size:11px;opacity:0.85;">يرجى التأكد من استلام المبلغ كاملاً من العميل قبل مشاركة مفتاح الترخيص</p>
            </td></tr>
          </table>

          <!-- License Key -->
          <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
            <tr><td style="background:${BRAND.primaryLight};border:2px solid ${BRAND.primary};border-radius:16px;padding:24px;text-align:center;">
              <p style="margin:0 0 8px;color:${BRAND.textSecondary};font-size:11px;letter-spacing:2px;font-weight:600;">مفتاح الترخيص</p>
              <p style="margin:0;color:${BRAND.primary};font-size:26px;font-weight:800;font-family:'Courier New',monospace;letter-spacing:3px;direction:ltr;">${formattedKey}</p>
            </td></tr>
          </table>

          <!-- QR Code -->
          <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:24px;">
            <tr><td align="center">
              <div style="display:inline-block;background:#fff;border:2px solid ${BRAND.border};border-radius:16px;padding:14px;">
                <img src="cid:qrcode" alt="QR Code" width="160" height="160" style="display:block;border-radius:8px;" />
                <p style="margin:8px 0 0;color:${BRAND.textSecondary};font-size:11px;">امسح الرمز لنسخ المفتاح</p>
              </div>
            </td></tr>
          </table>

          <!-- Details -->
          <table width="100%" cellpadding="0" cellspacing="0" style="background:#F8FAFC;border-radius:14px;overflow:hidden;border:1px solid ${BRAND.border};margin-bottom:24px;">
            <tr><td style="padding:14px 20px;border-bottom:1px solid ${BRAND.border};"><p style="margin:0;color:${BRAND.text};font-size:13px;font-weight:700;">تفاصيل الترخيص</p></td></tr>
            <tr><td style="padding:0;">
              <table width="100%" cellpadding="0" cellspacing="0">
                <tr style="background:#fff;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;border-bottom:1px solid #F1F5F9;width:35%;">اسم العميل</td><td style="padding:12px 20px;color:${BRAND.text};font-size:13px;font-weight:600;border-bottom:1px solid #F1F5F9;">${clientName}</td></tr>
                <tr style="background:#FAFBFC;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;border-bottom:1px solid #F1F5F9;">رقم الهاتف</td><td style="padding:12px 20px;color:${BRAND.text};font-size:13px;font-weight:600;border-bottom:1px solid #F1F5F9;" dir="ltr">${phone}</td></tr>
                <tr style="background:#fff;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;border-bottom:1px solid #F1F5F9;">رقم الجهاز</td><td style="padding:12px 20px;color:${BRAND.text};font-size:12px;font-weight:600;border-bottom:1px solid #F1F5F9;word-break:break-all;" dir="ltr">${deviceId}</td></tr>
                <tr style="background:#FAFBFC;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;border-bottom:1px solid #F1F5F9;">تاريخ الانتهاء</td><td style="padding:12px 20px;color:${BRAND.text};font-size:13px;font-weight:600;border-bottom:1px solid #F1F5F9;">${formattedExpiry}</td></tr>
                <tr style="background:#fff;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;border-bottom:1px solid #F1F5F9;">المسؤول</td><td style="padding:12px 20px;color:${BRAND.text};font-size:13px;font-weight:600;border-bottom:1px solid #F1F5F9;">${managerName || 'غير محدد'}</td></tr>
                <tr style="background:#FAFBFC;"><td style="padding:12px 20px;color:${BRAND.textSecondary};font-size:12px;">تاريخ التوليد</td><td style="padding:12px 20px;color:${BRAND.text};font-size:13px;font-weight:600;">${formattedDate}</td></tr>
              </table>
            </td></tr>
          </table>

          <!-- PDF note -->
          <table width="100%" cellpadding="0" cellspacing="0">
            <tr><td style="background:${BRAND.warningBg};border:1px solid #FDE68A;border-radius:12px;padding:14px 18px;text-align:center;">
              <p style="margin:0;color:${BRAND.warningText};font-size:12px;line-height:1.7;">
                نسخة PDF من الترخيص مرفقة مع هذا البريد الإلكتروني<br/>يرجى تسليم الترخيص للعميل <strong>بعد تأكيد الدفع فقط</strong>
              </p>
            </td></tr>
          </table>

        </td></tr>

        <!-- Footer -->
        <tr><td style="background:#F8FAFC;padding:20px 36px;text-align:center;border-top:1px solid ${BRAND.border};">
          <p style="margin:0;color:#94A3B8;font-size:10px;">شهريتي &copy; ${new Date().getFullYear()} &mdash; إشعار تلقائي من منصة شهريتي</p>
        </td></tr>

      </table>
    </td></tr>
  </table>
</body>
</html>`;
}

const sendToDelivery = onCall(
  { secrets: ['SMTP_USER', 'SMTP_PASS'] },
  async (request) => {
    verifyRole(request, ['manager', 'admin']);

    const { clientName, phone, deviceId, licenseKey, expiryDate, managerName, generatedAt } = request.data || {};

    if (!licenseKey) throw new HttpsError('invalid-argument', 'مفتاح الترخيص مطلوب');
    if (!clientName) throw new HttpsError('invalid-argument', 'اسم العميل مطلوب');

    const data = { clientName, phone, deviceId, licenseKey, expiryDate, managerName, generatedAt };

    const [pdfBuffer, qrBuffer] = await Promise.all([
      generatePDF(data),
      generateQRBuffer(licenseKey, 200),
    ]);
    const html = buildEmailHTML(data);

    const transporter = nodemailer.createTransport({
      service: 'gmail',
      auth: { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS },
    });

    const fileName = `license-${clientName.replace(/\s+/g, '-')}-${new Date().toISOString().slice(0, 10)}.pdf`;

    await transporter.sendMail({
      from: `"منصة شهريتي" <${process.env.SMTP_USER}>`,
      to: DELIVERY_EMAIL,
      subject: `ترخيص جديد: ${clientName}`,
      html,
      attachments: [
        { filename: fileName, content: pdfBuffer, contentType: 'application/pdf' },
        { filename: 'qrcode.png', content: qrBuffer, contentType: 'image/png', cid: 'qrcode' },
      ],
    });

    return { success: true, message: 'تم إرسال البريد الإلكتروني بنجاح' };
  }
);

module.exports = { sendToDelivery };
