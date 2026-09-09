import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/entities/index.dart';
import 'package:qr_reader/domain/repositories/device_role_repository.dart';

@injectable
class SaveDeviceRoleUsecase {
  const SaveDeviceRoleUsecase(this._repository);

  final DeviceRoleRepository _repository;

  Future<void> call(DeviceRole role) => _repository.saveRole(role);
}
