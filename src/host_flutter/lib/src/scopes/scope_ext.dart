import 'package:host_di/host_di.dart';
import 'package:flutter/widgets.dart';
import 'package:host_flutter/src/src.dart';

extension ScopeExtension on Scope {
  ScopeAnchor? wresolve<T extends Widget>({String? key}) {
    for (final anchor in iterate<ScopeAnchor>(key: key)) {
      if (anchor.child is T) {
        return anchor;
      }
    }
    return null;
  }

  Iterable<ScopeAnchor> witerate<T extends Widget>({String? key}) sync* {
    for (final anchor in iterate<ScopeAnchor>(key: key)) {
      if (anchor.child is T) {
        yield anchor;
      }
    }
  }
}
