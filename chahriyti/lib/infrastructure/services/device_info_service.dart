import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/value_objects/device_id.dart';

class DeviceInfoService {
  static const _deviceIdKey = 'chahriyti_device_id';
  final _deviceInfo = DeviceInfoPlugin();
  final _storage = const FlutterSecureStorage();

  Future<DeviceId> getDeviceId() async {
    // Try to get cached device ID first
    final cached = await _storage.read(key: _deviceIdKey);
    if (cached != null) return DeviceId(cached);

    // Generate from platform
    final rawId = await _getRawDeviceId();
    final deviceId = DeviceId.fromRawId(rawId);

    // Persist for future
    await _storage.write(key: _deviceIdKey, value: deviceId.value);
    return deviceId;
  }

  Future<String> _getRawDeviceId() async {
    if (Platform.isAndroid) {
      final info = await _deviceInfo.androidInfo;
      return info.id;
    } else if (Platform.isIOS) {
      final info = await _deviceInfo.iosInfo;
      return info.identifierForVendor ?? DateTime.now().toIso8601String();
    }
    return DateTime.now().toIso8601String();
  }
}
