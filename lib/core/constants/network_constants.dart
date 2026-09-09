import 'package:qr_reader/core/constants/device_identity.dart';
import 'package:qr_reader/core/constants/local_subnet_resolver.dart';

class NetworkConstants {
  // Every Cafe Beta device on one site shares a subnet (see
  // LocalSubnetResolver) — only the last octet is fixed per role, so a new
  // site (a different third octet) needs no code change or reinstall, just
  // its router pre-configured with these devices' addresses reserved.
  static String get mqttBrokerHost => '${LocalSubnetResolver.prefix}.240';
  static const int mqttBrokerPort = 1883;
  static const String mqttUsername = 'cafebeta';
  static const String mqttPassword = 'soundgraph@2026';

  static String get mqttDeviceId => DeviceIdentity.deviceId;
  static String get mqttDeviceName => DeviceIdentity.deviceName;

  // Message Hub's online-timeout window sits between 6s (stable) and 9s
  // (flapping) — 5s keeps a safety margin under that threshold.
  static const Duration mqttHeartbeatInterval = Duration(seconds: 5);
}
