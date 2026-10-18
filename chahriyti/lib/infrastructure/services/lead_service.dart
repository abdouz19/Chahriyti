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
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
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

  /// Sends an order from the in-app order form and waits for the server.
  /// A Cloud Function turns it into a WooCommerce order, like the website.
  /// Throws when the server can't be reached in time, so the user can retry.
  ///
  /// Doc id `order_<phone>`: a retry overwrites instead of duplicating, and
  /// it doesn't collide with an older app lead stored under the bare phone.
  Future<void> submitOrder({
    required String name,
    required String phone,
    required int wilayaCode,
    required String commune,
    required String deliveryType,
    required int deliveryFee,
    required int bookPrice,
    required String? fcmToken,
  }) async {
    await _db.collection('leads').doc('order_$phone').set({
      'name': name,
      'phone': phone,
      'wilayaCode': wilayaCode,
      'commune': commune,
      'deliveryType': deliveryType,
      'deliveryFee': deliveryFee,
      'bookPrice': bookPrice,
      'total': bookPrice + deliveryFee,
      'fcmToken': fcmToken,
      'submittedAt': FieldValue.serverTimestamp(),
      'status': 'pending',
    }).timeout(const Duration(seconds: 15));
  }

  /// Submits the lead and waits for the server's confirmation. Returns false
  /// if the phone was already registered. Throws when the server can't be
  /// reached in time, so the caller can show an error and let the user retry.
  ///
  /// The phone number is the document id: a retry after a timeout (while
  /// Firestore may still hold the first attempt in its offline queue)
  /// overwrites the same document instead of creating a duplicate.
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

    await _db.collection('leads').doc(phone).set({
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
    }).timeout(const Duration(seconds: 15));
    return true;
  }
}
