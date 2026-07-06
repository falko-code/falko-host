import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class FrozenScope(
  Iterable<MapEntry<String, ProvidersChain>> keyProviders,
  Iterable<MapEntry<Type, ProvidersChain>> typeProviders,
) implements Scope {
  final FrozenLookup<String, ProvidersChain> _keyProviders = .new(keyProviders);
  final FrozenLookup<Type, ProvidersChain> _typeProviders = .new(typeProviders);

  @override
  T? resolve<T>({String? key}) {
    return key == null
        ? _resolve<T>(_typeProviders.lookup(T))
        : _resolve<T>(_keyProviders.lookup(key));
  }

  @override
  Iterable<T> iterate<T>({String? key}) {
    return key == null
        ? _iterate<T>(_typeProviders.lookup(T))
        : _iterate<T>(_keyProviders.lookup(key));
  }

  T? _resolve<T>(ProvidersChain? context) {
    if (context == null) return null;
    return _cast<T>(context.primary.provide());
  }

  Iterable<T> _iterate<T>(ProvidersChain? context) {
    if (context != null) {
      return context.collisions.map((provider) => _cast<T>(provider.provide()));
    }
    return const Iterable.empty();
  }
}

@pragma('vm:prefer-inline')
T _cast<T>(Object value) {
  assert(value is T, 'Expected $T but got ${value.runtimeType}');
  return value as T;
}
