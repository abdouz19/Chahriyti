import 'dart:convert';
import 'package:http/http.dart' as http;

// Crockford Base32 alphabet — matches server-side
const _crockford = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

/// Result types for license activation.
sealed class LicenseActivationResult {
  const LicenseActivationResult();
}

class LicenseActivated extends LicenseActivationResult {
  const LicenseActivated();
}

class LicenseAlreadyActivated extends LicenseActivationResult {
  const LicenseAlreadyActivated();
}

class LicenseAlreadyUsed extends LicenseActivationResult {
  const LicenseAlreadyUsed();
}

class LicenseInvalid extends LicenseActivationResult {
  final String message;
  const LicenseInvalid(this.message);
}

class LicenseNetworkError extends LicenseActivationResult {
  final String message;
  const LicenseNetworkError(this.message);
}

class OnlineLicenseService {
  // TODO: Update this URL after deploying Cloud Functions
  static const _baseUrl =
      'https://us-central1-chahriyti-platform.cloudfunctions.net/activateLicense';

  /// Validate Luhn-mod-32 checksum on a Crockford Base32 string.
  /// Returns true if the last character is the correct check digit.
  static bool validateChecksum(String raw16) {
    if (raw16.length != 16) return false;

    // Verify all characters are in the Crockford alphabet
    for (var i = 0; i < 16; i++) {
      if (!_crockford.contains(raw16[i])) return false;
    }

    final data = raw16.substring(0, 15);
    int sum = 0;
    for (int i = 0; i < data.length; i++) {
      int val = _crockford.indexOf(data[i]);
      // Double every other position (from the right)
      if ((data.length - i) % 2 == 0) {
        val *= 2;
        if (val >= 32) val -= 31;
      }
      sum += val;
    }
    final check = (32 - (sum % 32)) % 32;
    return raw16[15] == _crockford[check];
  }

  /// Strip a formatted license key to its 16-char raw form.
  static String stripKey(String formatted) {
    return formatted
        .replaceAll(RegExp(r'^CHRY-'), '')
        .replaceAll('-', '')
        .toUpperCase();
  }

  /// Validate format: CHRY-XXXX-XXXX-XXXX-XXXX
  static bool isValidFormat(String key) {
    return RegExp(r'^CHRY-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}$')
        .hasMatch(key.toUpperCase());
  }

  /// Activate a license key on this device.
  /// Performs client-side validation (format + checksum) before making the network call.
  Future<LicenseActivationResult> activateLicense({
    required String licenseKey,
    required String deviceId,
  }) async {
    final cleaned = licenseKey.trim().toUpperCase();

    // Client-side format check
    if (!isValidFormat(cleaned)) {
      return const LicenseInvalid('صيغة مفتاح الترخيص غير صحيحة');
    }

    // Client-side checksum check (catches typos without network call)
    final raw = stripKey(cleaned);
    if (!validateChecksum(raw)) {
      return const LicenseInvalid('مفتاح الترخيص غير صحيح — تحقق من الأحرف');
    }

    // Network call to activation endpoint
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'licenseKey': cleaned,
              'deviceId': deviceId,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['success'] == true) {
        if (body['status'] == 'already_activated') {
          return const LicenseAlreadyActivated();
        }
        return const LicenseActivated();
      }

      // Error responses
      final error = body['error'] as String? ?? 'unknown';
      switch (error) {
        case 'not_found':
          return const LicenseInvalid('مفتاح الترخيص غير موجود');
        case 'already_used':
          return const LicenseAlreadyUsed();
        case 'rate_limited':
          return const LicenseNetworkError('محاولات كثيرة — حاول لاحقاً');
        case 'invalid_format':
        case 'invalid_checksum':
          return LicenseInvalid(body['message'] as String? ?? 'مفتاح غير صحيح');
        default:
          return LicenseInvalid(body['message'] as String? ?? 'خطأ غير متوقع');
      }
    } on http.ClientException {
      return const LicenseNetworkError('تحقق من اتصالك بالإنترنت');
    } catch (e) {
      return LicenseNetworkError('خطأ في الاتصال: ${e.toString()}');
    }
  }
}
