import 'package:host/src/src.dart';
import 'package:host_di/host_di.dart';
import 'package:meta/meta.dart';

@internal
final class AppHostBuilder extends HostBuilder {
  late final ScopeBuilder _scopeBuilder = const ScopeBuilderFactory().create();

  @override
  void extend(Module module) => _scopeBuilder.extend(module);

  @override
  void include(Module module) => _scopeBuilder.include(module);

  @override
  void require({required String key}) => _scopeBuilder.require(key: key);

  @override
  void provide<T>(
    ProviderInstanceFactory<T> factory, {
    String? key,
    bool cache = true,
  }) {
    return _scopeBuilder.provide(factory, key: key, cache: cache);
  }

  @override
  Host build() {
    _scopeBuilder.extend(const AppHostLifetimeModule());
    return AppHost(_scopeBuilder.build());
  }
}
