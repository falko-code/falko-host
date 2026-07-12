import 'package:host/src/src.dart';
import 'package:host_di/host_di.dart';

extension HostBuilderExtension on ScopeBuilder {
  void dispose<T>(ProviderInstanceFactory<Disposable> factory) {
    require(key: 'host:');
    provide<Disposable>(factory, key: 'lifetime:disposables');
  }

  void initialize<T>(ProviderInstanceFactory<Initializeable> factory) {
    require(key: 'host:');
    provide<Initializeable>(factory, key: 'lifetime:initializeables');
  }
}
