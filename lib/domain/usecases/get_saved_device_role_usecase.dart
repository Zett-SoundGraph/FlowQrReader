import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/entities/index.dart';
import 'package:qr_reader/domain/repositories/device_role_repository.dart';

@injectable
class GetSavedDeviceRoleUsecase {
  const GetSavedDeviceRoleUsecase(this._repository);

  final DeviceRoleRepository _repository;

  Future<DeviceRole?> call() => _repository.getSavedRole();
}
