import 'package:meta/meta.dart';

@internal
final class const ModuleKey(this.module, this.key) {
  final String? module;
  final String key;

  static ModuleKey? parse(String key) {
    final index = key.lastIndexOf(':');
    if (index < 0) return null;
    if (index == 0) return ModuleKey(null, key);
    return ModuleKey(key.substring(0, index), key.substring(index));
  }
}
