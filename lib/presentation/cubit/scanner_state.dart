import 'package:freezed_annotation/freezed_annotation.dart';

part 'scanner_state.freezed.dart';

@freezed
abstract class ScannerState with _$ScannerState {
  const factory ScannerState({
    @Default(false) bool isConnected,
    @Default('') String lastBarcode,
    @Default([]) List<String> logs,
  }) = _ScannerState;
}
