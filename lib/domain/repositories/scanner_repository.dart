abstract interface class ScannerRepository {
  /// Native (MethodChannel) barcode scan events, raw as scanned.
  Stream<String> get scanStream;

  /// MQTT broker connection state.
  Stream<bool> get connectionStream;

  Future<void> connect();

  /// Publishes [barcode] to this device's role-specific topic. Returns
  /// false (and publishes nothing) if the MQTT client isn't currently
  /// connected.
  bool publishScan(String barcode);
}
