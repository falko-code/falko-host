import 'package:host_di/host_di.dart';
import 'package:host/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class const AppHostLifetimeModule() extends Module {
  this : super('host');

  @override
  void initialize(ScopeBuilder builder) {
    builder.provide<HostLifetime>((scope) => AppHostLifetime(scope));
    builder.provide((scope) => scope.resolve<HostLifetime>(), key: ':lifetime');
  }
}
