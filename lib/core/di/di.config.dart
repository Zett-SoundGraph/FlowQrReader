// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories/device_role_repository_impl.dart' as _i1006;
import '../../data/repositories/scanner_repository_impl.dart' as _i818;
import '../../data/sources/local/device_role_data_source.dart' as _i531;
import '../../data/sources/remote/barcode_scan_data_source.dart' as _i293;
import '../../data/sources/remote/mqtt_data_source.dart' as _i126;
import '../../domain/repositories/device_role_repository.dart' as _i544;
import '../../domain/repositories/scanner_repository.dart' as _i846;
import '../../domain/usecases/connect_mqtt_usecase.dart' as _i151;
import '../../domain/usecases/get_saved_device_role_usecase.dart' as _i98;
import '../../domain/usecases/index.dart' as _i447;
import '../../domain/usecases/observe_connection_usecase.dart' as _i528;
import '../../domain/usecases/observe_scan_usecase.dart' as _i295;
import '../../domain/usecases/publish_scan_usecase.dart' as _i400;
import '../../domain/usecases/save_device_role_usecase.dart' as _i829;
import '../../presentation/cubit/scanner_cubit.dart' as _i799;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.singleton<_i126.IMqttDataSource>(() => _i126.MqttDataSource());
  gh.singleton<_i531.IDeviceRoleDataSource>(() => _i531.DeviceRoleDataSource());
  gh.singleton<_i293.IBarcodeScanDataSource>(
    () => _i293.BarcodeScanDataSource(),
  );
  gh.singleton<_i846.ScannerRepository>(
    () => _i818.ScannerRepositoryImpl(
      gh<_i293.IBarcodeScanDataSource>(),
      gh<_i126.IMqttDataSource>(),
    ),
  );
  gh.singleton<_i544.DeviceRoleRepository>(
    () => _i1006.DeviceRoleRepositoryImpl(gh<_i531.IDeviceRoleDataSource>()),
  );
  gh.factory<_i98.GetSavedDeviceRoleUsecase>(
    () => _i98.GetSavedDeviceRoleUsecase(gh<_i544.DeviceRoleRepository>()),
  );
  gh.factory<_i829.SaveDeviceRoleUsecase>(
    () => _i829.SaveDeviceRoleUsecase(gh<_i544.DeviceRoleRepository>()),
  );
  gh.factory<_i151.ConnectMqttUsecase>(
    () => _i151.ConnectMqttUsecase(gh<_i846.ScannerRepository>()),
  );
  gh.factory<_i528.ObserveConnectionUsecase>(
    () => _i528.ObserveConnectionUsecase(gh<_i846.ScannerRepository>()),
  );
  gh.factory<_i295.ObserveScanUsecase>(
    () => _i295.ObserveScanUsecase(gh<_i846.ScannerRepository>()),
  );
  gh.factory<_i400.PublishScanUsecase>(
    () => _i400.PublishScanUsecase(gh<_i846.ScannerRepository>()),
  );
  gh.factory<_i799.ScannerCubit>(
    () => _i799.ScannerCubit(
      gh<_i447.ConnectMqttUsecase>(),
      gh<_i447.ObserveConnectionUsecase>(),
      gh<_i447.ObserveScanUsecase>(),
      gh<_i447.PublishScanUsecase>(),
    ),
  );
  return getIt;
}
