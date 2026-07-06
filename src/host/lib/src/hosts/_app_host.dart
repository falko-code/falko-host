import 'package:host_di/host_di.dart';
import 'package:host/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class AppHost extends Host {
  AppHost(this._scope);

  final Scope _scope;

  @override
  Iterable<T> iterate<T>({String? key}) => _scope.iterate<T>(key: key);

  @override
  T? resolve<T>({String? key}) => _scope.resolve<T>(key: key);

  @override
  Future<void> run() async {
    final lifetime = _scope.resolve<HostLifetime>(key: 'lifetime:service')!;
    await lifetime.initialize();
    try {
      await lifetime.start();
    } finally {
      await lifetime.dispose();
    }
  }
}
