import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The one secure storage configuration of the app. Every use MUST go
/// through this: on Android, instances with different options share the same
/// file, and the encrypted one moves the other's values out of its reach
/// (that silently "lost" the tour flag, onboarding answers, language…).
const appSecureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);
