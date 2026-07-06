import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class ProvideByGlobalKeyOperation({
  required super.key,
  required super.source,
  required super.provider,
}) extends ScopeBuilderOperation<String>;
