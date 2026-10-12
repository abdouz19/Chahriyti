import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/storage/app_secure_storage.dart';

/// Persists the onboarding answers once the server received them, so the
/// user returns to the order screen after a cold restart.
class LeadStorage {
  static const _profileKey = 'onboarding_profile';
  final FlutterSecureStorage _storage;

  const LeadStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? appSecureStorage;

  Future<void> save({
    required String name,
    required String phone,
    required int wilayaCode,
    required int salary,
    required int salaryDay,
    String? commune,
    String? ageGroup,
    String? maritalStatus,
    bool? tracksExpenses,
    List<String> goals = const [],
  }) async {
    await _storage.write(
      key: _profileKey,
      value: jsonEncode({
        'name': name,
        'phone': phone,
        'wilayaCode': wilayaCode,
        'salary': salary,
        'salaryDay': salaryDay,
        'commune': commune,
        'ageGroup': ageGroup,
        'maritalStatus': maritalStatus,
        'tracksExpenses': tracksExpenses,
        'goals': goals,
      }),
    );
  }

  /// Returns profile map if saved, null otherwise.
  Future<Map<String, dynamic>?> load() async {
    final raw = await _storage.read(key: _profileKey);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> clear() => _storage.delete(key: _profileKey);
}
