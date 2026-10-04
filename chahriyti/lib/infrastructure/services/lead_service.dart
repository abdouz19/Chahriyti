import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class LeadService {
  final FirebaseFirestore _db;

  static const _checkUrl =
      'https://us-central1-chahriyati.cloudfunctions.net/checkLeadByPhone';
  static const _convertUrl =
      'https://us-central1-chahriyati.cloudfunctions.net/convertLead';

  LeadService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  /// Returns true if a lead with [phone] already exists in Firestore.
  Future<bool> _phoneExists(String phone) async {
    try {
      final uri = Uri.parse(_checkUrl).replace(queryParameters: {'phone': phone});
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return body['exists'] == true;
      }
    } catch (_) {
      // If the check fails, allow submission to proceed
    }
    return false;
  }

  /// Marks the lead with [phone] as converted (مُفعَّل) after license activation.
  Future<void> convertLead(String phone) async {
    try {
      await http
          .post(
            Uri.parse(_convertUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': phone}),
          )
          .timeout(const Duration(seconds: 10));
    } catch (_) {
      // Non-fatal — lead status update can be done manually if this fails
    }
  }

  /// Submits lead to Firestore only if the phone is not already registered.
  /// Returns true if data was sent to server, false if it was a duplicate.
  Future<bool> submitLead({
    required String name,
    required String phone,
    required int wilayaCode,
    required String? commune,
    required String? ageGroup,
    required int salary,
    required int salaryDay,
    required String? maritalStatus,
    required bool? tracksExpenses,
    required List<String> goals,
    required String? fcmToken,
  }) async {
    final exists = await _phoneExists(phone);
    if (exists) return false;

    await _db.collection('leads').add({
      'name': name,
      'phone': phone,
      'wilayaCode': wilayaCode,
      'commune': commune,
      'ageGroup': ageGroup,
      'salary': salary,
      'salaryDay': salaryDay,
      'maritalStatus': maritalStatus,
      'tracksExpenses': tracksExpenses,
      'goals': goals,
      'fcmToken': fcmToken,
      'submittedAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    });
    return true;
  }
}
