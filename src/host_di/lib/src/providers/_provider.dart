import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
abstract class Provider<T> {
  set scope(Scope scope);

  T provide();
}
