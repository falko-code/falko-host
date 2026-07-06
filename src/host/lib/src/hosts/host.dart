import 'package:host_di/host_di.dart';

abstract class Host implements Scope {
  Future<void> run();
}
