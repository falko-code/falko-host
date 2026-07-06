import 'package:host_di/host_di.dart';
import 'package:flutter/material.dart';

final class const ScopeAnchor({
  required super.child,
  required this.scope,
  super.key,
}) extends InheritedWidget {
  new from({required Widget child, required BuildContext context, Key? key})
    : this(child: child, key: key, scope: ScopeAnchor.of(context));

  final Scope scope;

  static Scope of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ScopeAnchor>()!.scope;
  }

  @override
  bool updateShouldNotify(ScopeAnchor oldWidget) {
    return !identical(oldWidget.scope, scope);
  }
}
