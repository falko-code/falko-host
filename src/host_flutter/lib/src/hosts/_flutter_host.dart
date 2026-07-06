import 'package:host_di/host_di.dart';
import 'package:flutter/foundation.dart';
import 'package:host/host.dart';

@internal
final class FlutterHost({required this._scope}) implements Host {
  final Scope _scope;
  @override
  Iterable<T> iterate<T>({String? key}) => _scope.iterate<T>(key: key);

  @override
  T? resolve<T>({String? key}) => _scope.resolve<T>(key: key);

  @override
  Future<void> run() async {
    final lifetime = _scope.resolve<HostLifetime>(key: 'host:lifetime')!;
    await lifetime.initialize();
    try {
      await lifetime.start();
    } finally {
      await lifetime.dispose();
    }
  }
}
