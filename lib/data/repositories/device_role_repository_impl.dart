import 'package:injectable/injectable.dart';

import 'package:qr_reader/data/sources/local/device_role_data_source.dart';
import 'package:qr_reader/domain/entities/index.dart';
import 'package:qr_reader/domain/repositories/device_role_repository.dart';

@Singleton(as: DeviceRoleRepository)
class DeviceRoleRepositoryImpl implements DeviceRoleRepository {
  const DeviceRoleRepositoryImpl(this._dataSource);

  final IDeviceRoleDataSource _dataSource;

  @override
  Future<DeviceRole?> getSavedRole() => _dataSource.getSavedRole();

  @override
  Future<void> saveRole(DeviceRole role) => _dataSource.saveRole(role);
}
