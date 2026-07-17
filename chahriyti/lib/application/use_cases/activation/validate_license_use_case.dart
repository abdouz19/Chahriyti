import '../../../domain/repositories/user_repository.dart';
import '../../../domain/value_objects/device_id.dart';
import '../../../infrastructure/services/license_service.dart';

class ValidateLicenseUseCase {
  final LicenseService _licenseService;
  final UserRepository _userRepo;

  const ValidateLicenseUseCase(this._licenseService, this._userRepo);

  Future<bool> call({
    required String licenseKey,
    required DeviceId deviceId,
  }) async {
    final isValid = _licenseService.validateKey(licenseKey, deviceId.displayFormat);
    if (isValid) {
      await _userRepo.setActivated(true);
    }
    return isValid;
  }
}
