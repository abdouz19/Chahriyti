/**
 * Validation utilities for the Chahriyti platform.
 * All error messages are in Arabic.
 * Each function returns null if valid, or an error message string if invalid.
 */

export function validateName(name) {
  if (!name || typeof name !== 'string' || name.trim().length === 0) {
    return 'الاسم مطلوب';
  }
  if (name.trim().length > 100) {
    return 'الاسم يجب أن لا يتجاوز 100 حرف';
  }
  return null;
}

export function validatePhone(phone) {
  if (!phone || typeof phone !== 'string') {
    return 'رقم الهاتف مطلوب';
  }

  const trimmed = phone.trim();

  // Format: starts with 0, exactly 10 digits
  const localPattern = /^0\d{9}$/;
  // Format: starts with +213, then 9 digits (12 chars total)
  const intlPattern = /^\+213\d{9}$/;

  if (localPattern.test(trimmed) || intlPattern.test(trimmed)) {
    return null;
  }

  return 'رقم الهاتف غير صالح';
}

export function validateDeviceId(deviceId) {
  if (!deviceId || typeof deviceId !== 'string' || deviceId.trim().length === 0) {
    return 'رقم الجهاز مطلوب';
  }

  const trimmed = deviceId.trim();

  if (trimmed.length < 4) {
    return 'رقم الجهاز غير صالح';
  }

  return null;
}

export function validateEmail(email) {
  if (!email || typeof email !== 'string' || email.trim().length === 0) {
    return 'البريد الإلكتروني مطلوب';
  }

  const trimmed = email.trim();
  // Basic email pattern: something@something.something
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (!emailPattern.test(trimmed)) {
    return 'البريد الإلكتروني غير صالح';
  }

  return null;
}

export function validatePassword(password) {
  if (!password || typeof password !== 'string') {
    return 'كلمة المرور مطلوبة';
  }

  if (password.length < 8) {
    return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
  }

  return null;
}
