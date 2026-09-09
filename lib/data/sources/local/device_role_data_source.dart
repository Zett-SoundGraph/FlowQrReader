import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/entities/index.dart';

abstract interface class IDeviceRoleDataSource {
  Future<DeviceRole?> getSavedRole();
  Future<void> saveRole(DeviceRole role);
}

/// Backed by a plain MethodChannel over Android's own SharedPreferences API
/// (see MainActivity.kt's PREFS_CHANNEL) rather than the `shared_preferences`
/// Flutter plugin — that plugin's Android implementation requires minSdk
/// 24+, which would conflict with this project's minSdk 23 (the real
/// scanner hardware runs Android 6.0.1).
@Singleton(as: IDeviceRoleDataSource)
class DeviceRoleDataSource implements IDeviceRoleDataSource {
  static const MethodChannel _channel = MethodChannel('com.sg.qr_reader/prefs');

  @override
  Future<DeviceRole?> getSavedRole() async {
    final saved = await _channel.invokeMethod<String>('getDeviceRole');
    if (saved == null) return null;
    for (final role in DeviceRole.values) {
      if (role.deviceId == saved) return role;
    }
    return null;
  }

  @override
  Future<void> saveRole(DeviceRole role) async {
    await _channel.invokeMethod<void>('setDeviceRole', role.deviceId);
  }
}
