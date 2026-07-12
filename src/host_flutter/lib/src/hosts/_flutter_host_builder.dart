import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:host/host.dart';
import 'package:host_di/host_di.dart';
import 'package:host_flutter/src/src.dart';

@internal
final class FlutterHostBuilder({required this._run}) implements HostBuilder {
  final ScopeBuilder _builder = const ScopeBuilderFactory().create();
  final ProviderInstanceFactory<Widget> _run;

  @override
  void extend(Module module) => _builder.extend(module);

  @override
  void include(Module module) => _builder.include(module);

  @override
  void require({required String key}) => _builder.require(key: key);

  @override
  void provide<T>(
    ProviderInstanceFactory<T> factory, {
    String? key,
    bool cache = true,
  }) {
    _builder.provide(factory, key: key, cache: cache);
  }

  @override
  Host build() {
    _builder.extend(FlutterLifetimeModule(_run));
    return FlutterHost(scope: _builder.build());
  }
}
