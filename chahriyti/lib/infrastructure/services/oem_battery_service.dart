import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OemBatteryService {
  static const _channel = MethodChannel('com.chahriyti.dz/oem');
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const _promptShownKey = 'oem_battery_prompt_shown';

  static const _restrictedOems = {
    'oppo', 'realme', 'xiaomi', 'redmi', 'huawei', 'honor', 'vivo', 'oneplus',
  };

  static Future<bool> isRestrictedOem() async {
    try {
      final manufacturer =
          await _channel.invokeMethod<String>('getManufacturer') ?? '';
      return _restrictedOems.contains(manufacturer.toLowerCase());
    } catch (_) {
      return false;
    }
  }

  static Future<bool> shouldShowPrompt() async {
    if (!await isRestrictedOem()) return false;
    final shown = await _storage.read(key: _promptShownKey);
    return shown == null;
  }

  static Future<void> markPromptShown() async {
    await _storage.write(key: _promptShownKey, value: '1');
  }

  static Future<void> openAutoStartSettings() async {
    try {
      await _channel.invokeMethod('openAutoStartSettings');
    } catch (_) {}
  }
}
