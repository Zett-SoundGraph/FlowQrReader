import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:qr_reader/core/constants/index.dart';
import 'package:qr_reader/core/di/index.dart';
import 'package:qr_reader/core/env/env.dart';
import 'package:qr_reader/presentation/screens/index.dart';

void main() {
  // Must come before setupLocator() — BarcodeScanDataSource's constructor
  // (eagerly instantiated as a @Singleton during $initGetIt) sets up a
  // MethodChannel handler, which needs ServicesBinding.instance to already
  // exist. runApp() would normally set this up on its own, but that's too
  // late here since setupLocator() runs before it.
  WidgetsFlutterBinding.ensureInitialized();
  // Not awaited — NetworkConstants.mqttBrokerHost falls back to the
  // currently-deployed site's subnet until this resolves, so nothing needs
  // to block on it (ConnectMqttUsecase already retries on its own and picks
  // up the corrected value automatically).
  LocalSubnetResolver.resolve();
  setupLocator(Env.dev());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const ScannerApp());
}

class ScannerApp extends StatelessWidget {
  const ScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DeviceRoleGate(),
    );
  }
}
