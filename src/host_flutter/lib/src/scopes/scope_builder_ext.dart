import 'package:host_di/host_di.dart';
import 'package:flutter/widgets.dart';
import 'package:host_flutter/src/src.dart';

extension ScopeBuilderExtension on ScopeBuilder {
  void wprovide<T extends Widget>(
    ProviderInstanceFactory<T> factory, {
    String? key,
  }) {
    provide(
      (scope) => ScopeAnchor(scope: scope, child: factory(scope)),
      key: key,
    );
  }
}
