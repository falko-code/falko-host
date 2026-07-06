import 'package:host_di/host_di.dart';
import 'package:host/src/src.dart';

abstract class HostBuilder extends ScopeBuilder {
  @override
  Host build();
}
