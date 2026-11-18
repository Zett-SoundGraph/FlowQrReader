import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:qr_reader/core/utils/log.dart';
import 'package:qr_reader/domain/usecases/device/get_device_info_usecase.dart';
import 'package:qr_reader/domain/usecases/device/observe_device_info_changed_usecase.dart';
import 'package:qr_reader/domain/usecases/index.dart';
import 'package:qr_reader/presentation/cubit/scanner_state.dart';

@injectable
class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(
    this._connectMqtt,
    this._observeConnection,
    this._observeScan,
    this._publishScan,
    this._getDeviceInfo,
    this._observeDeviceInfoChanged,
  ) : super(const ScannerState()) {
    _connectionSubscription = _observeConnection().listen((connected) {
      emit(state.copyWith(isConnected: connected));
      _appendLog(connected ? 'MQTT 브로커 연결됨' : 'MQTT 브로커 연결 끊김 — 재연결 시도 중...');
    });
    _scanSubscription = _observeScan().listen(_handleScan);
    unawaited(_connectMqtt());
    unawaited(_loadDeviceInfo());
    _deviceInfoChangedSubscription = _observeDeviceInfoChanged().listen(
      (_) => unawaited(_loadDeviceInfo()),
    );
  }

  final ConnectMqttUsecase _connectMqtt;
  final ObserveConnectionUsecase _observeConnection;
  final ObserveScanUsecase _observeScan;
  final PublishScanUsecase _publishScan;

  // FlowUpdater link: the device record is only logged for now (no UI yet).
  final GetDeviceInfoUsecase _getDeviceInfo;
  final ObserveDeviceInfoChangedUsecase _observeDeviceInfoChanged;

  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<String>? _scanSubscription;
  StreamSubscription<void>? _deviceInfoChangedSubscription;

  /// Reads the device record from FlowUpdater and logs it. No UI yet: the
  /// connection check is done through logcat (tag `QrReader`).
  Future<void> _loadDeviceInfo() async {
    try {
      final device = await _getDeviceInfo();
      if (isClosed) return;
      Log.i('QrReader', 'Device info loaded: $device');
    } catch (e) {
      Log.w('QrReader', 'getDeviceInfo failed: $e');
    }
  }

  void _handleScan(String barcode) {
    emit(state.copyWith(lastBarcode: barcode));
    _appendLog('🎯 스캔: $barcode');
    if (!_publishScan(barcode)) {
      _appendLog('⚠️ 전송 실패: MQTT 미연결');
    }
  }

  void _appendLog(String message) {
    emit(state.copyWith(logs: [message, ...state.logs]));
  }

  @override
  Future<void> close() {
    unawaited(_connectionSubscription?.cancel());
    unawaited(_scanSubscription?.cancel());
    unawaited(_deviceInfoChangedSubscription?.cancel());
    return super.close();
  }
}
