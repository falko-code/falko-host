import 'package:host/src/src.dart';

abstract class HostLifetime implements Initializeable, Disposable {
  Future<void>? start();
  Future<void>? stop();
}
