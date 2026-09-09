import 'package:flutter_test/flutter_test.dart';

import 'package:qr_reader/presentation/cubit/scanner_state.dart';

void main() {
  test('ScannerState defaults to disconnected with no scans', () {
    const state = ScannerState();
    expect(state.isConnected, isFalse);
    expect(state.lastBarcode, isEmpty);
    expect(state.logs, isEmpty);
  });
}
