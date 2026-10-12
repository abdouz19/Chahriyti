import '../../core/storage/app_secure_storage.dart';

class SecureStorageService {
  static const _licenseKeyStorageKey = 'chahriyti_license_key';

  final _storage = appSecureStorage;

  Future<void> saveLicenseKey(String key) =>
      _storage.write(key: _licenseKeyStorageKey, value: key);

  Future<String?> getLicenseKey() =>
      _storage.read(key: _licenseKeyStorageKey);

  Future<void> clearLicenseKey() =>
      _storage.delete(key: _licenseKeyStorageKey);
}
