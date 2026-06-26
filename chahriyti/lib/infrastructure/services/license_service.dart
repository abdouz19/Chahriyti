import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class LicenseService {
  // This secret is obfuscated in release builds via --obfuscate flag
  static const _secret = 'chahriyti_license_secret_2026';

  String generateKey(String deviceId, String expiryYYYYMM) {
    final key = utf8.encode(_secret);
    final msg = utf8.encode('$deviceId|$expiryYYYYMM');
    final hmac = Hmac(sha256, key).convert(msg).toString();
    final raw = hmac.substring(0, 16).toUpperCase();
    return 'CHRY-${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}-${raw.substring(12, 16)}';
  }

  bool validateKey(String licenseKey, String deviceId) {
    final cleanedKey = licenseKey.trim().toUpperCase();
    debugPrint('🔑 LICENSE VALIDATION START');
    debugPrint('   Entered Key: $cleanedKey');
    debugPrint('   Device ID: $deviceId');
    debugPrint('   Checking 900 months (75 years) forward...');

    // Try current month and next 900 months (~75 years for lifetime licenses)
    final now = DateTime.now();
    for (var i = 0; i < 900; i++) {
      // Properly calculate year and month with overflow
      final totalMonths = now.year * 12 + now.month + i;
      final year = totalMonths ~/ 12;
      final month = (totalMonths % 12);
      final safeMonth = month == 0 ? 12 : month;
      final safeYear = month == 0 ? year - 1 : year;

      final expiry = '$safeYear${safeMonth.toString().padLeft(2, '0')}';
      final expected = generateKey(deviceId, expiry);

      if (i == 0 || i == 1 || i % 12 == 0) {
        debugPrint('   Month +$i: Expiry=$expiry → Generated=$expected');
      }

      if (cleanedKey == expected) {
        debugPrint('✅ MATCH FOUND at month +$i (Expiry: $expiry)');
        return true;
      }
    }

    debugPrint('   Checking 12 months backward for recently expired...');
    // Also check past 12 months for recently expired
    for (var i = 1; i <= 12; i++) {
      final date = DateTime(now.year, now.month - i);
      final expiry =
          '${date.year}${date.month.toString().padLeft(2, '0')}';
      final expected = generateKey(deviceId, expiry);
      debugPrint('   Month -$i: Expiry=$expiry → Generated=$expected');

      if (cleanedKey == expected) {
        // Key matches but check if expired
        final expiryDate = DateTime(date.year, date.month + 1);
        final isValid = now.isBefore(expiryDate);
        debugPrint('   Match found but checking expiry: $isValid');
        return isValid;
      }
    }

    debugPrint('❌ NO MATCH FOUND - License key is invalid');
    return false;
  }
}
