import 'package:meta/meta.dart';

@internal
enum AppMode {
  development,
  production,
}

@internal
final AppMode appMode = _appMode();

AppMode _appMode() {
  const isDebug = bool.fromEnvironment('DEBUG') == true;
  const isProduct = bool.fromEnvironment('dart.vm.product') == true;
  return isDebug && !isProduct ? AppMode.development : AppMode.production;
}
