import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class SingletonProvider<T>(this._factory) extends Provider<T> {
  late final Scope _scope;
  final ProviderInstanceFactory<T> _factory;
  T? _instance;

  @override
  set scope(Scope scope) => _scope = scope;

  @override
  T provide() => _instance ??= _factory(_scope);
}
