import {
  validateName,
  validatePhone,
  validateDeviceId,
  validateEmail,
  validatePassword,
} from '../validators';

describe('validateName', () => {
  it('returns null for valid names', () => {
    expect(validateName('عبد الرؤوف')).toBeNull();
    expect(validateName('Ahmed')).toBeNull();
    expect(validateName('A')).toBeNull();
  });

  it('returns error for empty or missing name', () => {
    expect(validateName('')).toBe('الاسم مطلوب');
    expect(validateName(null)).toBe('الاسم مطلوب');
    expect(validateName(undefined)).toBe('الاسم مطلوب');
    expect(validateName('   ')).toBe('الاسم مطلوب');
  });

  it('returns error for non-string values', () => {
    expect(validateName(123)).toBe('الاسم مطلوب');
    expect(validateName(true)).toBe('الاسم مطلوب');
  });

  it('returns error for names exceeding 100 characters', () => {
    const longName = 'A'.repeat(101);
    expect(validateName(longName)).toBe('الاسم يجب أن لا يتجاوز 100 حرف');
  });

  it('returns null for names exactly 100 characters', () => {
    const exactName = 'A'.repeat(100);
    expect(validateName(exactName)).toBeNull();
  });
});

describe('validatePhone', () => {
  it('returns null for valid local phone numbers', () => {
    expect(validatePhone('0555123456')).toBeNull();
    expect(validatePhone('0661234567')).toBeNull();
    expect(validatePhone('0770123456')).toBeNull();
  });

  it('returns null for valid international format', () => {
    expect(validatePhone('+213555123456')).toBeNull();
    expect(validatePhone('+213661234567')).toBeNull();
  });

  it('returns error for empty or missing phone', () => {
    expect(validatePhone('')).toBe('رقم الهاتف مطلوب');
    expect(validatePhone(null)).toBe('رقم الهاتف مطلوب');
    expect(validatePhone(undefined)).toBe('رقم الهاتف مطلوب');
  });

  it('returns error for invalid phone formats', () => {
    expect(validatePhone('123456')).toBe('رقم الهاتف غير صالح');
    expect(validatePhone('055512345')).toBe('رقم الهاتف غير صالح'); // 9 digits
    expect(validatePhone('05551234567')).toBe('رقم الهاتف غير صالح'); // 11 digits
    expect(validatePhone('1555123456')).toBe('رقم الهاتف غير صالح'); // doesn't start with 0
    expect(validatePhone('+212555123456')).toBe('رقم الهاتف غير صالح'); // wrong country code
    expect(validatePhone('abcdefghij')).toBe('رقم الهاتف غير صالح');
  });

  it('returns error for non-string values', () => {
    expect(validatePhone(555123456)).toBe('رقم الهاتف مطلوب');
  });
});

describe('validateDeviceId', () => {
  it('returns null for valid hex device IDs (16+ chars)', () => {
    expect(validateDeviceId('abcdef0123456789')).toBeNull(); // exactly 16
    expect(validateDeviceId('ABCDEF0123456789')).toBeNull(); // uppercase hex
    expect(validateDeviceId('a1b2c3d4e5f6a7b8c9d0')).toBeNull(); // longer
  });

  it('returns error for empty or missing device ID', () => {
    expect(validateDeviceId('')).toBe('رقم الجهاز مطلوب');
    expect(validateDeviceId(null)).toBe('رقم الجهاز مطلوب');
    expect(validateDeviceId(undefined)).toBe('رقم الجهاز مطلوب');
    expect(validateDeviceId('   ')).toBe('رقم الجهاز مطلوب');
  });

  it('returns error for device IDs shorter than 16 chars', () => {
    expect(validateDeviceId('abcdef012345678')).toBe('رقم الجهاز غير صالح'); // 15 chars
    expect(validateDeviceId('abc')).toBe('رقم الجهاز غير صالح');
  });

  it('returns error for non-hex characters', () => {
    expect(validateDeviceId('ghijklmnopqrstuv')).toBe('رقم الجهاز غير صالح');
    expect(validateDeviceId('abcdef012345678g')).toBe('رقم الجهاز غير صالح');
    expect(validateDeviceId('abcdef01234567!@')).toBe('رقم الجهاز غير صالح');
  });

  it('returns error for non-string values', () => {
    expect(validateDeviceId(123)).toBe('رقم الجهاز مطلوب');
  });
});

describe('validateEmail', () => {
  it('returns null for valid emails', () => {
    expect(validateEmail('user@example.com')).toBeNull();
    expect(validateEmail('test.name@domain.co')).toBeNull();
    expect(validateEmail('a@b.c')).toBeNull();
  });

  it('returns error for empty or missing email', () => {
    expect(validateEmail('')).toBe('البريد الإلكتروني مطلوب');
    expect(validateEmail(null)).toBe('البريد الإلكتروني مطلوب');
    expect(validateEmail(undefined)).toBe('البريد الإلكتروني مطلوب');
    expect(validateEmail('   ')).toBe('البريد الإلكتروني مطلوب');
  });

  it('returns error for invalid email formats', () => {
    expect(validateEmail('user')).toBe('البريد الإلكتروني غير صالح');
    expect(validateEmail('user@')).toBe('البريد الإلكتروني غير صالح');
    expect(validateEmail('@domain.com')).toBe('البريد الإلكتروني غير صالح');
    expect(validateEmail('user@domain')).toBe('البريد الإلكتروني غير صالح');
    expect(validateEmail('user domain.com')).toBe('البريد الإلكتروني غير صالح');
  });

  it('returns error for non-string values', () => {
    expect(validateEmail(123)).toBe('البريد الإلكتروني مطلوب');
  });
});

describe('validatePassword', () => {
  it('returns null for valid passwords (8+ chars)', () => {
    expect(validatePassword('12345678')).toBeNull();
    expect(validatePassword('a very long password indeed')).toBeNull();
    expect(validatePassword('P@ssw0rd')).toBeNull();
  });

  it('returns error for empty or missing password', () => {
    expect(validatePassword('')).toBe('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    expect(validatePassword(null)).toBe('كلمة المرور مطلوبة');
    expect(validatePassword(undefined)).toBe('كلمة المرور مطلوبة');
  });

  it('returns error for passwords shorter than 8 characters', () => {
    expect(validatePassword('1234567')).toBe('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    expect(validatePassword('abc')).toBe('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    expect(validatePassword('a')).toBe('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
  });

  it('returns error for non-string values', () => {
    expect(validatePassword(12345678)).toBe('كلمة المرور مطلوبة');
  });
});
