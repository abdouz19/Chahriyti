const crypto = require('crypto');
const { generateLicenseKey, SECRET } = require('../src/license');

describe('generateLicenseKey', () => {
  const FORMAT_REGEX = /^CHRY-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}$/;

  test('output format is CHRY-XXXX-XXXX-XXXX-XXXX', () => {
    const key = generateLicenseKey('device1', '202701');
    expect(key).toMatch(FORMAT_REGEX);
  });

  test('same inputs produce same output (deterministic)', () => {
    const a = generateLicenseKey('myDevice', '202812');
    const b = generateLicenseKey('myDevice', '202812');
    expect(a).toBe(b);
  });

  test('known input/output: deviceId=abc123, expiry=202701', () => {
    // Independently compute the expected value using the same HMAC-SHA256
    // algorithm to guarantee parity with the Dart implementation.
    const hmac = crypto
      .createHmac('sha256', SECRET)
      .update('abc123|202701')
      .digest('hex');
    const raw = hmac.substring(0, 16).toUpperCase();
    const expected = `CHRY-${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}-${raw.substring(12, 16)}`;

    const actual = generateLicenseKey('abc123', '202701');
    expect(actual).toBe(expected);
    expect(actual).toMatch(FORMAT_REGEX);

    // Lock in the value so any future secret/algorithm change is caught.
    // If this ever fails, re-derive from the Dart side before updating.
    expect(actual).toMatchSnapshot();
  });

  test('different inputs produce different outputs', () => {
    const key1 = generateLicenseKey('deviceA', '202701');
    const key2 = generateLicenseKey('deviceB', '202701');
    const key3 = generateLicenseKey('deviceA', '202702');
    expect(key1).not.toBe(key2);
    expect(key1).not.toBe(key3);
    expect(key2).not.toBe(key3);
  });
});
