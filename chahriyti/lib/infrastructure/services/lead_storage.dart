import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists onboarding profile locally so the user can resume after a cold restart.
class LeadStorage {
  static const _profileKey = 'onboarding_profile';
  final FlutterSecureStorage _storage;

  const LeadStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> save({
    required String name,
    required String phone,
    required int wilayaCode,
    required int salary,
    required int salaryDay,
  }) =>
      _storage.write(
        key: _profileKey,
        value: jsonEncode({
          'name': name,
          'phone': phone,
          'wilayaCode': wilayaCode,
          'salary': salary,
          'salaryDay': salaryDay,
        }),
      );

  /// Returns profile map if saved, null otherwise.
  Future<Map<String, dynamic>?> load() async {
    final raw = await _storage.read(key: _profileKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clear() => _storage.delete(key: _profileKey);
}
