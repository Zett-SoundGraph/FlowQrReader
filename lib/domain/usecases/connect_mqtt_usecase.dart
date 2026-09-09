import 'package:injectable/injectable.dart';

import 'package:qr_reader/domain/repositories/scanner_repository.dart';

@injectable
class ConnectMqttUsecase {
  const ConnectMqttUsecase(this._repository);

  final ScannerRepository _repository;

  Future<void> call() => _repository.connect();
}
