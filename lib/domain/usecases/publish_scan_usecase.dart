import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/repositories/scanner_repository.dart';

@injectable
class PublishScanUsecase {
  const PublishScanUsecase(this._repository);

  final ScannerRepository _repository;

  bool call(String barcode) => _repository.publishScan(barcode);
}
