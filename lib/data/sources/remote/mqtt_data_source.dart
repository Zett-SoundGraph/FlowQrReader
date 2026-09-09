import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:qr_reader/core/constants/index.dart';
import 'package:qr_reader/core/utils/log.dart';

abstract interface class IMqttDataSource {
  Stream<bool> get connectionStream;
  Future<void> connect();

  /// Publishes [barcode] to this device's role-specific topic. Returns
  /// false (and publishes nothing) if not currently connected.
  bool publishScan(String barcode);
  void dispose();
}

/// Publishes scanned QR/barcode data to the local MQTT broker (Message Hub).
@Singleton(as: IMqttDataSource)
class MqttDataSource implements IMqttDataSource {
  static const _tag = 'Mqtt';
  // autoReconnect only takes over once a client has connected successfully
  // at least once — it never fires for a connect() call that fails outright
  // (e.g. broker/network not up yet), so a failed FIRST attempt would
  // otherwise never retry on its own. Most visible at boot: a race against
  // this device's own network stack coming up can lose once and then sit
  // disconnected forever without this.
  static const _retryInterval = Duration(seconds: 5);

  MqttServerClient? _client;
  Timer? _heartbeatTimer;
  Timer? _retryTimer;
  final StreamController<bool> _connectionController = StreamController<bool>.broadcast();

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Future<void> connect() async {
    // Guard against duplicate live connections under the same client ID
    // (would otherwise fight the broker for the same identity every reconnect).
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      return;
    }
    _retryTimer?.cancel();
    _client?.disconnect();

    // Waits for this device's own subnet to be confirmed before ever
    // dialing out — a brand-new site (whose subnet doesn't match
    // NetworkConstants.mqttBrokerHost's currently-deployed-site fallback)
    // would otherwise always waste a doomed first attempt before
    // self-correcting on a later retry.
    await LocalSubnetResolver.ready;

    final client = MqttServerClient(
      NetworkConstants.mqttBrokerHost,
      NetworkConstants.mqttDeviceId,
    );
    client.port = NetworkConstants.mqttBrokerPort;
    // 15s — comfortably above the 5s heartbeat interval, but short enough
    // that a dead connection gets noticed (and auto-reconnect kicks in)
    // quickly instead of taking up to 30s.
    client.keepAlivePeriod = 15;
    client.autoReconnect = true;
    client.logging(on: false);
    client.onConnected = () {
      _connectionController.add(true);
      Log.d(_tag, 'Connected to broker (${NetworkConstants.mqttBrokerHost}:${NetworkConstants.mqttBrokerPort})');
      _startHeartbeat();
    };
    client.onDisconnected = () {
      _connectionController.add(false);
      Log.w(_tag, 'Disconnected from broker — reconnecting...');
    };

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(NetworkConstants.mqttDeviceId)
        .authenticateAs(NetworkConstants.mqttUsername, NetworkConstants.mqttPassword)
        .startClean();

    try {
      await client.connect();
    } catch (e) {
      Log.e(_tag, 'Connect error: $e — retrying in ${_retryInterval.inSeconds}s');
      client.disconnect();
      _scheduleRetry();
      return;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      Log.e(_tag, 'Connection failed: ${client.connectionStatus} — retrying in ${_retryInterval.inSeconds}s');
      client.disconnect();
      _scheduleRetry();
      return;
    }

    _client = client;
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(_retryInterval, () => unawaited(connect()));
  }

  // Which topic a scan publishes to is derived from this device's own
  // deviceId (scanner-order-01 / scanner-complete-01 / scanner-customer-01)
  // — hardcoding this to one topic regardless of role would send a
  // complete/customer station's scans to the order topic instead.
  String get _topicForRole {
    final id = NetworkConstants.mqttDeviceId;
    if (id.startsWith('scanner-complete')) return 'beta/qr/complete';
    if (id.startsWith('scanner-customer')) return 'beta/qr/customer';
    return 'beta/qr/order';
  }

  @override
  bool publishScan(String barcode) {
    final client = _client;
    if (client == null || client.connectionStatus?.state != MqttConnectionState.connected) {
      Log.w(_tag, 'Publish skipped: MQTT not connected');
      return false;
    }

    final builder = MqttClientPayloadBuilder();
    // addUTF8String, not addString — see flowhub's mqtt_data_source.dart for
    // why addString silently corrupts any non-ASCII payload.
    builder.addUTF8String(jsonEncode({
      'raw': barcode,
      'eventId': '${NetworkConstants.mqttDeviceId}-${DateTime.now().millisecondsSinceEpoch}',
    }));
    client.publishMessage(_topicForRole, MqttQos.atLeastOnce, builder.payload!);
    Log.d(_tag, 'Published scan ($_topicForRole): $barcode');
    return true;
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _publishHeartbeat();
    _heartbeatTimer = Timer.periodic(NetworkConstants.mqttHeartbeatInterval, (_) => _publishHeartbeat());
  }

  void _publishHeartbeat() {
    final client = _client;
    if (client == null || client.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(jsonEncode({
      'status': 'online',
      'deviceName': NetworkConstants.mqttDeviceName,
      'deviceId': NetworkConstants.mqttDeviceId,
    }));
    client.publishMessage(
      'beta/system/heartbeat/${NetworkConstants.mqttDeviceId}',
      MqttQos.atMostOnce,
      builder.payload!,
      retain: true,
    );
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _retryTimer?.cancel();
    _client?.disconnect();
    unawaited(_connectionController.close());
  }
}
