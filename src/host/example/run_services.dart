// ignore_for_file: avoid_print

import 'package:host_di/host_di.dart';
import 'package:host/host.dart';

Future<void> main() {
  final builder = const AppHostFactory().create()
    ..extend(const ServicesModule())
    ..extend(const ServicesModule());
  return builder.build().run();
}

final class const ServicesModule() extends Module {
  this : super('services');

  @override
  void initialize(ScopeBuilder builder) {
    builder
      ..provide((scope) => MyService(scope.resolve(key: 'lifetime:shutdown')!))
      ..initialize((scope) => scope.resolve<MyService>()!)
      ..dispose((scope) => scope.resolve<MyService>()!);
  }
}

final class MyService(this.shutdown) implements Initializeable, Disposable {
  final Function shutdown;

  @override
  Future<void>? initialize() async {
    print('Service initialized');
    Future.delayed(const Duration(seconds: 5), () => shutdown());
  }

  @override
  Future<void>? dispose() async {
    print('Service disposed');
  }
}
