const crypto = require('crypto');

const SECRET = 'chahriyti_license_secret_2026';

// Crockford Base32 alphabet — excludes confusable characters (I, L, O, U)
const CROCKFORD = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/**
 * Generate a license key from a device ID and expiry month (legacy HMAC).
 *
 * Produces the same output as the Dart implementation:
 *   CHRY-XXXX-XXXX-XXXX-XXXX
 *
 * @param {string} deviceId  - unique device identifier
 * @param {string} expiryYYYYMM - expiry in YYYYMM format (e.g. '202701')
 * @returns {string} formatted license key
 */
function generateLicenseKey(deviceId, expiryYYYYMM) {
  const hmac = crypto
    .createHmac('sha256', SECRET)
    .update(`${deviceId}|${expiryYYYYMM}`)
    .digest('hex');

  const raw = hmac.substring(0, 16).toUpperCase();

  return `CHRY-${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}-${raw.substring(12, 16)}`;
}

/**
 * Compute Luhn-mod-32 checksum character for a Crockford Base32 string.
 *
 * @param {string} input - string of Crockford Base32 characters
 * @returns {string} single checksum character
 */
function luhnMod32Checksum(input) {
  let sum = 0;
  for (let i = 0; i < input.length; i++) {
    let val = CROCKFORD.indexOf(input[i]);
    // Double every other position (from the right)
    if ((input.length - i) % 2 === 0) {
      val *= 2;
      if (val >= 32) val -= 31;
    }
    sum += val;
  }
  const check = (32 - (sum % 32)) % 32;
  return CROCKFORD[check];
}

/**
 * Validate Luhn-mod-32 checksum on a 16-char Crockford Base32 string.
 * Last character is the check digit.
 *
 * @param {string} raw16 - 16 Crockford Base32 characters (15 random + 1 check)
 * @returns {boolean}
 */
function validateChecksum(raw16) {
  if (raw16.length !== 16) return false;
  const data = raw16.substring(0, 15);
  const expected = luhnMod32Checksum(data);
  return raw16[15] === expected;
}

/**
 * Generate a cryptographically random pool license key.
 *
 * Uses crypto.randomBytes for true randomness with Crockford Base32 encoding.
 * Format: CHRY-XXXX-XXXX-XXXX-XXXX (15 random + 1 checksum = 16 chars)
 * Entropy: 75 bits (15 chars × 5 bits each)
 *
 * @returns {string} formatted license key
 */
function generatePoolLicenseKey() {
  const bytes = crypto.randomBytes(15);
  let raw = '';
  for (let i = 0; i < 15; i++) {
    raw += CROCKFORD[bytes[i] % 32];
  }
  raw += luhnMod32Checksum(raw);
  return formatLicenseKey(raw);
}

/**
 * Format a 16-char raw key string into CHRY-XXXX-XXXX-XXXX-XXXX.
 *
 * @param {string} raw16 - 16 characters
 * @returns {string} formatted key
 */
function formatLicenseKey(raw16) {
  return `CHRY-${raw16.substring(0, 4)}-${raw16.substring(4, 8)}-${raw16.substring(8, 12)}-${raw16.substring(12, 16)}`;
}

/**
 * Strip a formatted license key to its 16-char raw form.
 *
 * @param {string} formatted - e.g. "CHRY-XXXX-XXXX-XXXX-XXXX"
 * @returns {string} 16 uppercase characters
 */
function stripLicenseKey(formatted) {
  return formatted.replace(/^CHRY-/, '').replace(/-/g, '').toUpperCase();
}

module.exports = {
  generateLicenseKey,
  generatePoolLicenseKey,
  luhnMod32Checksum,
  validateChecksum,
  formatLicenseKey,
  stripLicenseKey,
  CROCKFORD,
  SECRET,
};
