import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/usecases/index.dart';
import 'package:qr_reader/presentation/cubit/scanner_state.dart';

@injectable
class ScannerCubit extends Cubit<ScannerState> {
  ScannerCubit(
    this._connectMqtt,
    this._observeConnection,
    this._observeScan,
    this._publishScan,
  ) : super(const ScannerState()) {
    _connectionSubscription = _observeConnection().listen((connected) {
      emit(state.copyWith(isConnected: connected));
      _appendLog(connected ? 'MQTT 브로커 연결됨' : 'MQTT 브로커 연결 끊김 — 재연결 시도 중...');
    });
    _scanSubscription = _observeScan().listen(_handleScan);
    unawaited(_connectMqtt());
  }

  final ConnectMqttUsecase _connectMqtt;
  final ObserveConnectionUsecase _observeConnection;
  final ObserveScanUsecase _observeScan;
  final PublishScanUsecase _publishScan;

  StreamSubscription<bool>? _connectionSubscription;
  StreamSubscription<String>? _scanSubscription;

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
    return super.close();
  }
}
