import 'package:host/src/src.dart';
import 'package:host_di/host_di.dart';

abstract class HostBuilder extends ScopeBuilder {
  @override
  Host build();
}
