/**
 * Formatting utilities for the Chahriyti platform.
 * Date-related messages are in Arabic.
 */

/**
 * Convert a Firestore timestamp or Date to 'YYYY-MM-DD HH:mm'.
 */
export function formatDate(timestamp) {
  if (!timestamp) return '';

  let date;
  if (timestamp.toDate && typeof timestamp.toDate === 'function') {
    // Firestore Timestamp
    date = timestamp.toDate();
  } else if (timestamp instanceof Date) {
    date = timestamp;
  } else if (typeof timestamp === 'number') {
    date = new Date(timestamp);
  } else {
    return '';
  }

  if (isNaN(date.getTime())) return '';

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');

  return `${year}-${month}-${day} ${hours}:${minutes}`;
}

/**
 * Convert a Firestore timestamp or Date to 'YYYY-MM-DD'.
 */
export function formatDateShort(timestamp) {
  if (!timestamp) return '';

  let date;
  if (timestamp.toDate && typeof timestamp.toDate === 'function') {
    date = timestamp.toDate();
  } else if (timestamp instanceof Date) {
    date = timestamp;
  } else if (typeof timestamp === 'number') {
    date = new Date(timestamp);
  } else {
    return '';
  }

  if (isNaN(date.getTime())) return '';

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');

  return `${year}-${month}-${day}`;
}

/**
 * Format a phone number with spaces: '0555123456' -> '0555 12 34 56'
 */
export function formatPhone(phone) {
  if (!phone || typeof phone !== 'string') return '';

  const digits = phone.replace(/\D/g, '');

  if (digits.length === 10 && digits.startsWith('0')) {
    return `${digits.slice(0, 4)} ${digits.slice(4, 6)} ${digits.slice(6, 8)} ${digits.slice(8, 10)}`;
  }

  // Return as-is if format is unrecognized
  return phone;
}

/**
 * Format a number with thousands separator: 1234 -> '1,234'
 */
export function formatNumber(num) {
  if (num === null || num === undefined) return '';
  if (typeof num !== 'number' || isNaN(num)) return '';

  return num.toLocaleString('en-US');
}

/**
 * Ensure a license key is uppercase. Expected format: CHRY-XXXX-...
 */
export function formatLicenseKey(key) {
  if (!key || typeof key !== 'string') return '';
  return key.toUpperCase();
}

/**
 * Format a date relative to today in Arabic.
 * 'اليوم', 'أمس', 'N أيام', etc.
 */
export function formatRelativeDate(date) {
  if (!date) return '';

  let target;
  if (date.toDate && typeof date.toDate === 'function') {
    target = date.toDate();
  } else if (date instanceof Date) {
    target = date;
  } else if (typeof date === 'number') {
    target = new Date(date);
  } else {
    return '';
  }

  if (isNaN(target.getTime())) return '';

  const now = new Date();
  // Compare by calendar day, not exact milliseconds
  const todayStart = new Date(now.getFullYear(), now.getMonth(), now.getDate());
  const targetStart = new Date(target.getFullYear(), target.getMonth(), target.getDate());

  const diffMs = todayStart.getTime() - targetStart.getTime();
  const diffDays = Math.round(diffMs / (1000 * 60 * 60 * 24));

  if (diffDays === 0) return 'اليوم';
  if (diffDays === 1) return 'أمس';
  if (diffDays === 2) return 'يومين';
  if (diffDays > 2 && diffDays <= 10) return `${diffDays} أيام`;
  if (diffDays > 10) return `${diffDays} يوم`;

  // Future dates
  if (diffDays === -1) return 'غداً';
  if (diffDays < -1) return `بعد ${Math.abs(diffDays)} أيام`;

  return '';
}

/**
 * Returns YYYYMM string for N months from now.
 */
export function getExpiryYYYYMM(monthsFromNow) {
  if (monthsFromNow === null || monthsFromNow === undefined || typeof monthsFromNow !== 'number') {
    return '';
  }

  const now = new Date();
  const target = new Date(now.getFullYear(), now.getMonth() + monthsFromNow, 1);

  const year = target.getFullYear();
  const month = String(target.getMonth() + 1).padStart(2, '0');

  return `${year}${month}`;
}
