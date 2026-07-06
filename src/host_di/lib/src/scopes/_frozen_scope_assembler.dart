import 'dart:collection';

import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class FrozenScopeAssembler(this._operations, this._modules) {
  final _keyProviders = <Module?, HashMap<String, List<Provider>>>{};
  final _typeProviders = <Module?, HashMap<Type, List<Provider>>>{};

  final Iterable<ScopeBuilderOperation> _operations;
  final Iterable<Module?> _modules;

  Scope assemble() {
    for (final module in _modules) {
      _keyProviders[module] = HashMap<String, List<Provider>>();
      _typeProviders[module] = HashMap<Type, List<Provider>>();
    }
    _applyOperations();
    final moduleScopes = _buildModuleScopes();
    _assignProviderScopes(moduleScopes);
    return moduleScopes[null]!; // root scope is always the null module
  }

  Map<Module?, FrozenScope> _buildModuleScopes() {
    final moduleScopes = <Module?, FrozenScope>{};
    for (final module in {..._keyProviders.keys, ..._typeProviders.keys}) {
      moduleScopes[module] = FrozenScope(
        _keyProviders[module]!.entries.map(
          (e) => MapEntry(e.key, ProvidersChain(e.value)),
        ),
        _typeProviders[module]!.entries.map(
          (e) => MapEntry(e.key, ProvidersChain(e.value)),
        ),
      );
    }
    return moduleScopes;
  }

  void _assignProviderScopes(Map<Module?, FrozenScope> moduleScopes) {
    for (final operation in _operations) {
      operation.provider.scope =
          moduleScopes[operation.source] ?? moduleScopes[null]!;
    }
  }

  void _applyOperations() {
    for (final operation in _operations) {
      switch (operation) {
        case final ProvideByInstanceTypeOperation operation:
          _applyInstanceTypeOperation(operation);
        case final ProvideByModuleKeyOperation operation:
          _applyModuleKeyOperation(operation);
        case final ProvideByGlobalKeyOperation operation:
          _applyGlobalKeyOperation(operation);
        case final ProvideByPrivateKeyOperation operation:
          _applyPrivateKeyOperation(operation);
      }
    }
  }

  void _applyGlobalKeyOperation(ProvideByGlobalKeyOperation operation) {
    for (final module in _modules) {
      _addProviderByKey(
        module: module,
        key: operation.key,
        provider: operation.provider,
      );
    }
  }

  void _applyModuleKeyOperation(ProvideByModuleKeyOperation operation) {
    if (operation.target != null) {
      _addProviderByKey(
        module: _matchModule(operation),
        key: operation.key,
        provider: operation.provider,
      );
    } else {
      final globalModuleKey = operation.source!.name + operation.key;
      for (final module in _modules) {
        _addProviderByKey(
          module: operation.source,
          key: globalModuleKey,
          provider: operation.provider,
        );
      }
    }
  }

  void _applyPrivateKeyOperation(ProvideByPrivateKeyOperation operation) {
    _addProviderByKey(
      module: operation.source,
      key: operation.key,
      provider: operation.provider,
    );
  }

  void _applyInstanceTypeOperation(ProvideByInstanceTypeOperation operation) {
    _addProviderByType(
      module: operation.source,
      type: operation.key,
      provider: operation.provider,
    );
  }

  Module? _matchModule(ProvideByModuleKeyOperation operation) {
    return _modules.firstWhere((module) => module?.name == operation.target);
  }

  void _addProviderByKey({
    required Module? module,
    required String key,
    required Provider provider,
  }) {
    _addProvider<String>(
      providersMap: _keyProviders,
      module: module,
      key: key,
      provider: provider,
    );
  }

  void _addProviderByType({
    required Module? module,
    required Type type,
    required Provider provider,
  }) {
    _addProvider<Type>(
      providersMap: _typeProviders,
      module: module,
      key: type,
      provider: provider,
    );
  }

  void _addProvider<T>({
    required Map<Module?, HashMap<dynamic, List<Provider>>> providersMap,
    required Module? module,
    required T key,
    required Provider provider,
  }) {
    providersMap[module]!.update(
      key,
      (providers) => providers..add(provider),
      ifAbsent: () => [provider],
    );
  }
}
