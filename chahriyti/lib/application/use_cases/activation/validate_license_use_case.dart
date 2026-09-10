import '../../../domain/repositories/user_repository.dart';
import '../../../domain/value_objects/device_id.dart';
import '../../../infrastructure/services/online_license_service.dart';

/// Possible outcomes of license validation.
enum ValidationResult {
  success,
  alreadyUsed,
  invalid,
  networkError,
}

class ValidateLicenseUseCase {
  final OnlineLicenseService _onlineLicenseService;
  final UserRepository _userRepo;

  const ValidateLicenseUseCase(this._onlineLicenseService, this._userRepo);

  Future<ValidationResult> call({
    required String licenseKey,
    required DeviceId deviceId,
  }) async {
    final result = await _onlineLicenseService.activateLicense(
      licenseKey: licenseKey,
      deviceId: deviceId.displayFormat,
    );

    switch (result) {
      case LicenseActivated():
      case LicenseAlreadyActivated():
        await _userRepo.setActivated(true);
        return ValidationResult.success;
      case LicenseAlreadyUsed():
        return ValidationResult.alreadyUsed;
      case LicenseInvalid():
        return ValidationResult.invalid;
      case LicenseNetworkError():
        return ValidationResult.networkError;
    }
  }
}
