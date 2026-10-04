import 'dart:async';

import '../../../domain/repositories/user_repository.dart';
import '../../../domain/value_objects/device_id.dart';
import '../../../infrastructure/services/lead_service.dart';
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
  final LeadService _leadService;

  ValidateLicenseUseCase(
    this._onlineLicenseService,
    this._userRepo, [
    LeadService? leadService,
  ]) : _leadService = leadService ?? LeadService();

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
        final user = await _userRepo.getUser();
        if (user?.phoneNumber != null) {
          unawaited(_leadService.convertLead(user!.phoneNumber));
        }
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
