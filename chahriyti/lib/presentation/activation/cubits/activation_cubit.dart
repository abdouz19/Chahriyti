import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/use_cases/activation/get_device_id_use_case.dart';
import '../../../application/use_cases/activation/validate_license_use_case.dart';
import '../../../application/use_cases/activation/compose_whatsapp_message_use_case.dart';
import '../../../core/constants/wilayas.dart';
import '../../../domain/value_objects/device_id.dart';

// ---------------------------------------------------------------------------
// States
// ---------------------------------------------------------------------------

sealed class ActivationState {
  const ActivationState();
}

final class ActivationLoading extends ActivationState {
  const ActivationLoading();
}

final class ActivationReady extends ActivationState {
  final DeviceId deviceId;
  const ActivationReady(this.deviceId);
}

final class ActivationSending extends ActivationState {
  const ActivationSending();
}

final class ActivationValidating extends ActivationState {
  const ActivationValidating();
}

final class ActivationSuccess extends ActivationState {
  const ActivationSuccess();
}

final class ActivationError extends ActivationState {
  final String message;
  const ActivationError(this.message);
}

// ---------------------------------------------------------------------------
// Cubit
// ---------------------------------------------------------------------------

class ActivationCubit extends Cubit<ActivationState> {
  final GetDeviceIdUseCase _getDeviceIdUseCase;
  final ValidateLicenseUseCase _validateLicenseUseCase;
  final ComposeWhatsAppMessageUseCase _composeWhatsAppMessageUseCase;

  DeviceId? _deviceId;
  DeviceId? get deviceId => _deviceId;

  ActivationCubit({
    required GetDeviceIdUseCase getDeviceIdUseCase,
    required ValidateLicenseUseCase validateLicenseUseCase,
    required ComposeWhatsAppMessageUseCase composeWhatsAppMessageUseCase,
  })  : _getDeviceIdUseCase = getDeviceIdUseCase,
        _validateLicenseUseCase = validateLicenseUseCase,
        _composeWhatsAppMessageUseCase = composeWhatsAppMessageUseCase,
        super(const ActivationLoading());

  Future<void> loadDeviceId() async {
    emit(const ActivationLoading());
    try {
      _deviceId = await _getDeviceIdUseCase();
      emit(ActivationReady(_deviceId!));
    } catch (_) {
      emit(const ActivationError('فشل في تحديد هوية الجهاز'));
    }
  }

  String composeWhatsAppUrl({
    required String name,
    required String phone,
    required int wilayaCode,
  }) {
    final wilaya = Wilayas.all.firstWhere(
      (w) => w.code == wilayaCode,
      orElse: () => const Wilaya(0, 'غير معروف'),
    );
    return _composeWhatsAppMessageUseCase(
      name: name,
      phone: phone,
      wilayaName: wilaya.arabicName,
      deviceId: _deviceId?.displayFormat ?? '',
    );
  }

  Future<void> validateLicense(String key) async {
    if (_deviceId == null) {
      emit(const ActivationError('لم يتم تحديد هوية الجهاز بعد'));
      return;
    }
    emit(const ActivationValidating());
    try {
      final isValid = await _validateLicenseUseCase(
        licenseKey: key,
        deviceId: _deviceId!,
      );
      if (isValid) {
        emit(const ActivationSuccess());
      } else {
        emit(ActivationReady(_deviceId!));
        // Emit error after ready so UI can show dialog error while keeping state
        emit(const ActivationError('مفتاح التفعيل غير صحيح أو منتهي الصلاحية'));
      }
    } catch (_) {
      emit(const ActivationError('فشل التحقق من مفتاح التفعيل'));
    }
  }
}
