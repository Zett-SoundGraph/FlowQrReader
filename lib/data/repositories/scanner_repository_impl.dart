import 'package:injectable/injectable.dart';

import 'package:qr_reader/data/sources/remote/barcode_scan_data_source.dart';
import 'package:qr_reader/data/sources/remote/mqtt_data_source.dart';
import 'package:qr_reader/domain/repositories/scanner_repository.dart';

@Singleton(as: ScannerRepository)
class ScannerRepositoryImpl implements ScannerRepository {
  const ScannerRepositoryImpl(this._scanDataSource, this._mqttDataSource);

  final IBarcodeScanDataSource _scanDataSource;
  final IMqttDataSource _mqttDataSource;

  @override
  Stream<String> get scanStream => _scanDataSource.scanStream;

  @override
  Stream<bool> get connectionStream => _mqttDataSource.connectionStream;

  @override
  Future<void> connect() => _mqttDataSource.connect();

  @override
  bool publishScan(String barcode) => _mqttDataSource.publishScan(barcode);
}
