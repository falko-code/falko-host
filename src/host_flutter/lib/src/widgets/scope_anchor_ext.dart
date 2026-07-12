import 'package:flutter/widgets.dart';
import 'package:host_di/host_di.dart';
import 'package:host_flutter/src/src.dart';

extension ScopeAnchorExtension on BuildContext {
  Scope get scope => ScopeAnchor.of(this);
}

Scope scope(BuildContext context) => context.scope;
