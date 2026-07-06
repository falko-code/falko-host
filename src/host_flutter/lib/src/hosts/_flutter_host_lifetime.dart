import 'package:host_di/host_di.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:host/host.dart';

@internal
final class FlutterHostLifetime({required this._scope, required this._run})
    extends HostLifetime {
  final Scope _scope;
  final ProviderInstanceFactory<Widget> _run;

  @override
  Future<void>? initialize() async {
    for (final initializeable in _scope.iterate<Initializeable>(
      key: ':initializeables',
    )) {
      await initializeable.initialize();
    }
  }

  @override
  Future<void>? start() {
    runApp(_run(_scope));
    return null;
  }

  @override
  Future<void>? stop() {
    // Flutter does not provide a way to stop the app programmatically.
    return null;
  }

  @override
  Future<void>? dispose() async {
    for (final disposable in _scope.iterate<Disposable>(key: ':disposables')) {
      await disposable.dispose();
    }
  }
}
