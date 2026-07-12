import 'dart:async';
import 'dart:isolate';

import 'package:host/src/src.dart';
import 'package:host_di/host_di.dart';
import 'package:meta/meta.dart';

@internal
final class AppHostLifetime(this._scope) implements HostLifetime {
  final Scope _scope;
  _AppHostCompleter? _completer;

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
    final completer = _completer ??= .new();
    return completer.wait();
  }

  @override
  Future<void>? stop() {
    final completer = _completer;
    _completer = null;
    completer?.dispose();
    return null;
  }

  @override
  Future<void>? dispose() async {
    for (final disposable in _scope.iterate<Disposable>(key: ':disposables')) {
      await disposable.dispose();
    }
  }
}

final class _AppHostCompleter() implements Disposable {
  final Completer<void> _completer = .new();
  final RawReceivePort _keepAlive = .new()..keepIsolateAlive = true;

  Future<void> wait() => _completer.future;

  @override
  Future<void>? dispose() {
    if (_completer.isCompleted) return null;
    _keepAlive.close();
    _completer.complete();
    return null;
  }
}
