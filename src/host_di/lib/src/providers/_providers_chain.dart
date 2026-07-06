import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class ProvidersChain(Iterable<Provider> providers) {
  final Provider primary = providers.last;
  final Iterable<Provider> collisions = List.unmodifiable(providers);
}
