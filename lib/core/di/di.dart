import 'package:injectable/injectable.dart';

import 'package:qr_reader/core/di/di.config.dart';
import 'package:qr_reader/core/di/service_locator.dart';
import 'package:qr_reader/core/env/env.dart';

export 'package:qr_reader/core/di/service_locator.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void setupLocator(Env env) {
  getIt.registerSingleton<Env>(env);
  $initGetIt(getIt);
}
