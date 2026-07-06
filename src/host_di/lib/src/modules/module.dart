import 'package:host_di/src/src.dart';
import 'package:meta/meta.dart';

@immutable
abstract class const Module(this.name) {
  final String name;

  void initialize(ScopeBuilder builder);
}
