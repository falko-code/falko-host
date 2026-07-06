import 'package:host_di/src/src.dart';

abstract class ScopeBuilder {
  void require({required String key});

  void provide<T>(
    ProviderInstanceFactory<T> factory, {
    String? key,
    bool cache = true,
  });

  void include(Module module);

  void extend(Module module);

  Scope build();
}
