// License Key Generator CLI Tool
// Usage: dart run tools/generate_license.dart --device-id <DEVICE_ID> --expiry <YYYYMM>
//
// Example:
//   dart run tools/generate_license.dart \
//     --device-id "a1b2c3d4e5f6..." \
//     --expiry "202701"

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const _secret = 'chahriyti_license_secret_2026';

String generateKey(String deviceId, String expiryYYYYMM) {
  final key = utf8.encode(_secret);
  final msg = utf8.encode('$deviceId|$expiryYYYYMM');
  final hmac = Hmac(sha256, key).convert(msg).toString();
  final raw = hmac.substring(0, 16).toUpperCase();
  return 'CHRY-${raw.substring(0, 4)}-${raw.substring(4, 8)}-${raw.substring(8, 12)}-${raw.substring(12, 16)}';
}

void main(List<String> args) {
  String? deviceId;
  String? expiry;

  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--device-id' && i + 1 < args.length) {
      deviceId = args[i + 1];
      i++;
    } else if (args[i] == '--expiry' && i + 1 < args.length) {
      expiry = args[i + 1];
      i++;
    }
  }

  if (deviceId == null || expiry == null) {
    stderr.writeln('Usage: dart run tools/generate_license.dart '
        '--device-id <DEVICE_ID> --expiry <YYYYMM>');
    stderr.writeln('');
    stderr.writeln('  --device-id   The SHA-256 hashed device identifier');
    stderr.writeln('  --expiry      Expiry month in YYYYMM format (e.g. 202701)');
    exit(1);
  }

  if (!RegExp(r'^\d{6}$').hasMatch(expiry)) {
    stderr.writeln('Error: --expiry must be in YYYYMM format (e.g. 202701)');
    exit(1);
  }

  final key = generateKey(deviceId, expiry);

  stdout.writeln('Device ID: $deviceId');
  stdout.writeln('Expiry:    $expiry');
  stdout.writeln('');
  stdout.writeln('License Key: $key');
}
