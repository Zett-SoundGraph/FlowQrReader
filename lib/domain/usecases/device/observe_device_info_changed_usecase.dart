import 'package:qr_reader/domain/repositories/device_repository.dart';
import 'package:injectable/injectable.dart';

/// Fires when FlowUpdater refreshed the device record (`device.changed`).
@injectable
class ObserveDeviceInfoChangedUsecase {
  const ObserveDeviceInfoChangedUsecase(this._repository);

  final DeviceRepository _repository;

  Stream<void> call() => _repository.deviceInfoChanges;
}
