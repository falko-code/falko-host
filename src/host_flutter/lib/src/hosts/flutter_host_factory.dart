import 'package:flutter/widgets.dart';
import 'package:host/host.dart';
import 'package:host_di/host_di.dart';
import 'package:host_flutter/src/src.dart';

final class const FlutterHostFactory() {
  HostBuilder create({required ProviderInstanceFactory<Widget> run}) {
    return FlutterHostBuilder(run: run);
  }
}
