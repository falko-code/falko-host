import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:host/host.dart';
import 'package:host_di/host_di.dart';
import 'package:host_flutter/src/src.dart';

@internal
final class const FlutterLifetimeModule(this._run) extends Module {
  this : super('host');

  final ProviderInstanceFactory<Widget> _run;

  @override
  void initialize(ScopeBuilder builder) {
    builder.provide<HostLifetime>(
      (scope) => FlutterHostLifetime(scope: scope, run: _run),
      key: ':lifetime',
    );
  }
}
