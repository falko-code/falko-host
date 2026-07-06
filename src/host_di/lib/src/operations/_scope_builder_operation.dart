import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
abstract class const ScopeBuilderOperation<T>({
  required this.key,
  required this.source,
  required this.provider,
}) {
  final T key;
  final Module? source;
  final Provider provider;
}
