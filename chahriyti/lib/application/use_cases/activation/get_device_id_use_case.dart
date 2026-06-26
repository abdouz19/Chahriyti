import '../../../domain/value_objects/device_id.dart';
import '../../../infrastructure/services/device_info_service.dart';

class GetDeviceIdUseCase {
  final DeviceInfoService _deviceInfoService;

  const GetDeviceIdUseCase(this._deviceInfoService);

  Future<DeviceId> call() => _deviceInfoService.getDeviceId();
}
