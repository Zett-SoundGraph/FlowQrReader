import 'package:qr_reader/domain/entities/index.dart';

/// Fixed identity — never changes once registered with Message Hub, but
/// which of the 3 fixed roles THIS physical unit is now comes from the
/// on-device role picker (DeviceRolePickerScreen) instead of being baked in
/// at build time — see DeviceRoleGate, which calls [apply] before ever
/// constructing ScannerCubit/connecting to MQTT.
class DeviceIdentity {
  const DeviceIdentity._();

  static String deviceId = '';

  // Display label shown on the Message Hub dashboard — safe to change anytime.
  static String deviceName = '';

  static void apply(DeviceRole role) {
    deviceId = role.deviceId;
    // Was role.deviceId here too (pre-existing bug) — deviceName always
    // published the same lowercase/hyphenated slug as deviceId instead of
    // the actual pretty label, e.g. "flow-qr-reader-brew" instead of
    // "Flow QR Reader Brew".
    deviceName = role.label;
  }
}
