import 'package:qr_reader/domain/entities/device/device.dart';
import 'package:qr_reader/domain/repositories/device_repository.dart';
import 'package:injectable/injectable.dart';

/// Reads the device record from FlowUpdater (`device.getInfo`). Throws when
/// FlowUpdater does not answer.
@injectable
class GetDeviceInfoUsecase {
  const GetDeviceInfoUsecase(this._repository);

  final DeviceRepository _repository;

  Future<Device> call() => _repository.getDeviceInfo();
}
