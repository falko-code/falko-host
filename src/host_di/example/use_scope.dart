// ignore_for_file: avoid_print

import 'package:host_di/host_di.dart';

void main() {
  final builder = const ScopeBuilderFactory().create();
  builder.provide((scope) => _HelloService());
  final scope = builder.build();
  scope.resolve<_HelloService>()!.sayHello();
}

final class _HelloService() {
  void sayHello() => print('Hello, World!');
}
