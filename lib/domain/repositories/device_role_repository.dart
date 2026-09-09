import 'package:qr_reader/domain/entities/index.dart';

abstract interface class DeviceRoleRepository {
  /// The role saved on a previous run, or null if this device has never had
  /// one picked yet (fresh install, or storage was cleared).
  Future<DeviceRole?> getSavedRole();

  /// Persists [role] — survives app restarts and device power cycles, and
  /// stays in effect until a later call overwrites it.
  Future<void> saveRole(DeviceRole role);
}
