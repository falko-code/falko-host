import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class TransientProvider<T>(this._factory) extends Provider<T> {
  late final Scope _scope;
  final ProviderInstanceFactory<T> _factory;

  @override
  set scope(Scope scope) => _scope = scope;

  @override
  T provide() => _factory(_scope);
}
