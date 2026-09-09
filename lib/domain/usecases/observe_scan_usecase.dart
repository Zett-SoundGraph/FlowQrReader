import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/repositories/scanner_repository.dart';

@injectable
class ObserveScanUsecase {
  const ObserveScanUsecase(this._repository);

  final ScannerRepository _repository;

  Stream<String> call() => _repository.scanStream;
}
