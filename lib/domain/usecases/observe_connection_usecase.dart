import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/repositories/scanner_repository.dart';

@injectable
class ObserveConnectionUsecase {
  const ObserveConnectionUsecase(this._repository);

  final ScannerRepository _repository;

  Stream<bool> call() => _repository.connectionStream;
}
