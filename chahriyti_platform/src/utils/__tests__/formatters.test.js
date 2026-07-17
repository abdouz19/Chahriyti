import {
  formatDate,
  formatDateShort,
  formatPhone,
  formatNumber,
  formatLicenseKey,
  formatRelativeDate,
  getExpiryYYYYMM,
} from '../formatters';

describe('formatDate', () => {
  it('formats a Date object to YYYY-MM-DD HH:mm', () => {
    const date = new Date(2025, 0, 15, 9, 5); // Jan 15, 2025 09:05
    expect(formatDate(date)).toBe('2025-01-15 09:05');
  });

  it('formats a Firestore-like timestamp', () => {
    const firestoreTs = {
      toDate: () => new Date(2024, 11, 25, 14, 30), // Dec 25, 2024 14:30
    };
    expect(formatDate(firestoreTs)).toBe('2024-12-25 14:30');
  });

  it('formats a numeric timestamp', () => {
    const ms = new Date(2025, 5, 1, 0, 0).getTime(); // Jun 1, 2025 00:00
    expect(formatDate(ms)).toBe('2025-06-01 00:00');
  });

  it('returns empty string for null/undefined', () => {
    expect(formatDate(null)).toBe('');
    expect(formatDate(undefined)).toBe('');
  });

  it('returns empty string for unsupported types', () => {
    expect(formatDate('not a date')).toBe('');
    expect(formatDate({})).toBe('');
  });

  it('pads single-digit months, days, hours, minutes', () => {
    const date = new Date(2025, 0, 5, 3, 7); // Jan 5, 2025 03:07
    expect(formatDate(date)).toBe('2025-01-05 03:07');
  });
});

describe('formatDateShort', () => {
  it('formats a Date object to YYYY-MM-DD', () => {
    const date = new Date(2025, 2, 20); // Mar 20, 2025
    expect(formatDateShort(date)).toBe('2025-03-20');
  });

  it('formats a Firestore-like timestamp', () => {
    const firestoreTs = {
      toDate: () => new Date(2024, 0, 1),
    };
    expect(formatDateShort(firestoreTs)).toBe('2024-01-01');
  });

  it('formats a numeric timestamp', () => {
    const ms = new Date(2025, 11, 31).getTime();
    expect(formatDateShort(ms)).toBe('2025-12-31');
  });

  it('returns empty string for null/undefined', () => {
    expect(formatDateShort(null)).toBe('');
    expect(formatDateShort(undefined)).toBe('');
  });
});

describe('formatPhone', () => {
  it('formats 10-digit local number with spaces', () => {
    expect(formatPhone('0555123456')).toBe('0555 12 34 56');
  });

  it('formats another local number', () => {
    expect(formatPhone('0661234567')).toBe('0661 23 45 67');
  });

  it('returns original string for non-standard formats', () => {
    expect(formatPhone('+213555123456')).toBe('+213555123456');
    expect(formatPhone('12345')).toBe('12345');
  });

  it('returns empty string for null/undefined', () => {
    expect(formatPhone(null)).toBe('');
    expect(formatPhone(undefined)).toBe('');
    expect(formatPhone('')).toBe('');
  });

  it('returns empty string for non-string input', () => {
    expect(formatPhone(123)).toBe('');
  });
});

describe('formatNumber', () => {
  it('formats numbers with thousands separators', () => {
    expect(formatNumber(1234)).toBe('1,234');
    expect(formatNumber(1000000)).toBe('1,000,000');
    expect(formatNumber(999)).toBe('999');
  });

  it('handles zero', () => {
    expect(formatNumber(0)).toBe('0');
  });

  it('handles negative numbers', () => {
    expect(formatNumber(-1234)).toBe('-1,234');
  });

  it('handles decimals', () => {
    const result = formatNumber(1234.56);
    expect(result).toContain('1,234');
  });

  it('returns empty string for null/undefined/NaN', () => {
    expect(formatNumber(null)).toBe('');
    expect(formatNumber(undefined)).toBe('');
    expect(formatNumber(NaN)).toBe('');
  });

  it('returns empty string for non-number types', () => {
    expect(formatNumber('1234')).toBe('');
  });
});

describe('formatLicenseKey', () => {
  it('converts to uppercase', () => {
    expect(formatLicenseKey('chry-abcd-1234')).toBe('CHRY-ABCD-1234');
  });

  it('keeps already uppercase keys as-is', () => {
    expect(formatLicenseKey('CHRY-ABCD-1234')).toBe('CHRY-ABCD-1234');
  });

  it('handles mixed case', () => {
    expect(formatLicenseKey('Chry-AbCd-1234')).toBe('CHRY-ABCD-1234');
  });

  it('returns empty string for null/undefined', () => {
    expect(formatLicenseKey(null)).toBe('');
    expect(formatLicenseKey(undefined)).toBe('');
    expect(formatLicenseKey('')).toBe('');
  });

  it('returns empty string for non-string input', () => {
    expect(formatLicenseKey(123)).toBe('');
  });
});

describe('formatRelativeDate', () => {
  it('returns "اليوم" for today', () => {
    expect(formatRelativeDate(new Date())).toBe('اليوم');
  });

  it('returns "أمس" for yesterday', () => {
    const yesterday = new Date();
    yesterday.setDate(yesterday.getDate() - 1);
    expect(formatRelativeDate(yesterday)).toBe('أمس');
  });

  it('returns "يومين" for 2 days ago', () => {
    const twoDaysAgo = new Date();
    twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);
    expect(formatRelativeDate(twoDaysAgo)).toBe('يومين');
  });

  it('returns "N أيام" for 3-10 days ago', () => {
    const fiveDaysAgo = new Date();
    fiveDaysAgo.setDate(fiveDaysAgo.getDate() - 5);
    expect(formatRelativeDate(fiveDaysAgo)).toBe('5 أيام');
  });

  it('returns "N يوم" for more than 10 days ago', () => {
    const fifteenDaysAgo = new Date();
    fifteenDaysAgo.setDate(fifteenDaysAgo.getDate() - 15);
    expect(formatRelativeDate(fifteenDaysAgo)).toBe('15 يوم');
  });

  it('returns "غداً" for tomorrow', () => {
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    expect(formatRelativeDate(tomorrow)).toBe('غداً');
  });

  it('handles future dates beyond tomorrow', () => {
    const threeDaysLater = new Date();
    threeDaysLater.setDate(threeDaysLater.getDate() + 3);
    expect(formatRelativeDate(threeDaysLater)).toBe('بعد 3 أيام');
  });

  it('handles Firestore-like timestamps', () => {
    const firestoreTs = {
      toDate: () => new Date(),
    };
    expect(formatRelativeDate(firestoreTs)).toBe('اليوم');
  });

  it('returns empty string for null/undefined', () => {
    expect(formatRelativeDate(null)).toBe('');
    expect(formatRelativeDate(undefined)).toBe('');
  });

  it('returns empty string for unsupported types', () => {
    expect(formatRelativeDate('not a date')).toBe('');
    expect(formatRelativeDate({})).toBe('');
  });
});

describe('getExpiryYYYYMM', () => {
  it('returns correct YYYYMM for 0 months from now', () => {
    const now = new Date();
    const expected =
      `${now.getFullYear()}${String(now.getMonth() + 1).padStart(2, '0')}`;
    expect(getExpiryYYYYMM(0)).toBe(expected);
  });

  it('returns correct YYYYMM for 1 month from now', () => {
    const target = new Date();
    target.setMonth(target.getMonth() + 1);
    const expected =
      `${target.getFullYear()}${String(target.getMonth() + 1).padStart(2, '0')}`;
    expect(getExpiryYYYYMM(1)).toBe(expected);
  });

  it('returns correct YYYYMM for 12 months from now', () => {
    const target = new Date();
    target.setMonth(target.getMonth() + 12);
    const expected =
      `${target.getFullYear()}${String(target.getMonth() + 1).padStart(2, '0')}`;
    expect(getExpiryYYYYMM(12)).toBe(expected);
  });

  it('handles year rollover', () => {
    // This test uses a large offset to ensure year rollover
    const target = new Date();
    target.setMonth(target.getMonth() + 24);
    const expected =
      `${target.getFullYear()}${String(target.getMonth() + 1).padStart(2, '0')}`;
    expect(getExpiryYYYYMM(24)).toBe(expected);
  });

  it('returns empty string for null/undefined', () => {
    expect(getExpiryYYYYMM(null)).toBe('');
    expect(getExpiryYYYYMM(undefined)).toBe('');
  });

  it('returns empty string for non-number input', () => {
    expect(getExpiryYYYYMM('3')).toBe('');
  });
});
