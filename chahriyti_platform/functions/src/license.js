const crypto = require('crypto');

const SECRET = 'chahriyti_license_secret_2026';

/**
 * Generate a license key from a device ID and expiry month.
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

module.exports = { generateLicenseKey, SECRET };
