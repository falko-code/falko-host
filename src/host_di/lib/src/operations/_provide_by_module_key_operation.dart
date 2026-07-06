import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@internal
final class ProvideByModuleKeyOperation({
  required super.key,
  required super.source,
  required this.target,
  required super.provider,
}) extends ScopeBuilderOperation<String> {
  final String? target;
}
