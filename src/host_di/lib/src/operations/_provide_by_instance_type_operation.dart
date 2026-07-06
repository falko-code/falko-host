import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class ProvideByInstanceTypeOperation({
  required super.key,
  required super.source,
  required super.provider,
}) extends ScopeBuilderOperation<Type>;
