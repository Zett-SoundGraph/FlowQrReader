import 'dart:async';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import 'package:qr_reader/core/utils/log.dart';

abstract interface class IBarcodeScanDataSource {
  Stream<String> get scanStream;
  void dispose();
}

@Singleton(as: IBarcodeScanDataSource)
class BarcodeScanDataSource implements IBarcodeScanDataSource {
  static const _tag = 'Scanner';
  static const MethodChannel _channel = MethodChannel('com.sg.scanner/scanner');

  final StreamController<String> _scanController = StreamController<String>.broadcast();

  BarcodeScanDataSource() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onScan') {
        final data = call.arguments.toString();
        Log.d(_tag, 'Scan received: $data');
        if (!_scanController.isClosed) _scanController.add(data);
      }
    });
  }

  @override
  Stream<String> get scanStream => _scanController.stream;

  @override
  void dispose() => _scanController.close();
}
