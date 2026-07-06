import 'dart:collection';

import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class FrozenScopeBuilder([
  Module? module,
  List<ScopeBuilderOperation>? operations,
  List<Module?>? modules,
]) implements ScopeBuilder {
  final Module? _module = module;
  final List<ScopeBuilderOperation> _operations = operations ?? [];
  final List<Module?> _modules = modules ?? [null];
  late final HashSet<String> _requires = .new();

  @override
  void extend(Module module) {
    module.initialize(_copyBuilder(module));
    _modules.add(module);
  }

  @override
  void include(Module module) => module.initialize(this);

  @override
  void require({required String key}) => _requires.add(key);

  @override
  void provide<T>(
    ProviderInstanceFactory<T> factory, {
    String? key,
    bool cache = true,
  }) {
    final provider = _buildProvider(factory, cache: cache);
    if (key == null) {
      _provideByInstanceType<T>(provider);
    } else if (key.startsWith('_')) {
      _provideByPrivateKey(key, provider);
    } else if (ModuleKey.parse(key) case final moduleKey?) {
      _provideByModuleKey(moduleKey, provider);
    } else {
      _provideByGlobalKey(key, provider);
    }
  }

  @override
  Scope build() => FrozenScopeAssembler(_operations, _modules).assemble();

  Provider _buildProvider<T>(
    ProviderInstanceFactory<T> factory, {
    bool cache = true,
  }) {
    return cache ? SingletonProvider(factory) : TransientProvider(factory);
  }

  FrozenScopeBuilder _copyBuilder(Module? module) {
    return FrozenScopeBuilder(module, _operations, _modules);
  }

  void _provideByInstanceType<T>(Provider provider) {
    _operations.add(
      ProvideByInstanceTypeOperation(
        key: T,
        source: _module,
        provider: provider,
      ),
    );
  }

  void _provideByPrivateKey(String key, Provider provider) {
    _operations.add(
      ProvideByPrivateKeyOperation(
        key: key,
        source: _module,
        provider: provider,
      ),
    );
  }

  void _provideByModuleKey(ModuleKey moduleKey, Provider provider) {
    _operations.add(
      ProvideByModuleKeyOperation(
        key: moduleKey.key,
        target: moduleKey.module,
        source: _module,
        provider: provider,
      ),
    );
  }

  void _provideByGlobalKey(String key, Provider provider) {
    _operations.add(
      ProvideByGlobalKeyOperation(
        key: key,
        source: _module,
        provider: provider,
      ),
    );
  }
}
