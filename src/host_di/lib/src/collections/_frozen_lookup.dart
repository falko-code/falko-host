import 'dart:typed_data';

import 'package:meta/meta.dart';

/// A read-only map that you build once and then look up in very fast.
/// It remembers the keys you asked for most recently in a tiny cache, so
/// repeating the same lookups is almost free. Anything not in the cache is
/// found in a compact hash table. Because it never changes after it is built,
/// it can stay small and fast.
@internal
final class FrozenLookup<TKey extends Object, TValue extends Object> {
  new(Iterable<MapEntry<TKey, TValue>> entries) {
    final list = entries.toList();

    var capacity = _minCapacity;
    // grow to power of 2, load <= 0.5
    while (capacity < list.length * _growthFactor) {
      capacity <<= 1;
    }

    _slotMask = capacity - 1; // fast modulo via bitwise AND
    _fingerprints = Int32List(capacity);

    _keys = List.filled(capacity, null);
    _values = List.filled(capacity, null);

    for (final entry in list) {
      _insert(entry.key, entry.value);
    }
  }

  static const _setCount = 16;
  static const _setMask = _setCount - 1;
  static const _wayA = 0;
  static const _wayB = 1;

  static const _minCapacity = 4; // smallest table size (power of 2)
  static const _growthFactor = 2; // grow until load factor <= 0.5

  // Fingerprint (top 32 bits of a slot) derived from the key's hashCode.
  static const _fingerprintShift = 32; // fingerprint lives in the high 32 bits
  static const _hashMask = 0x7FFFFFFF; // keep 31 positive bits of hashCode
  static const _oddBit = 1; // force fingerprint odd; 0 then means "empty slot"

  late final int _slotMask;
  late final Int32List _fingerprints;
  late final List<TKey?> _keys;
  late final List<TValue?> _values;

  final List<TKey?> _cacheWayAKey = List.filled(
    _setCount,
    null,
  ); // way A: cached keys per set

  final List<TKey?> _cacheWayBKey = List.filled(
    _setCount,
    null,
  ); // way B: cached keys per set

  final List<TValue?> _cacheWayAValue = List.filled(
    _setCount,
    null,
  ); // way A: matching values

  final List<TValue?> _cacheWayBValue = List.filled(
    _setCount,
    null,
  ); // way B: matching values

  final Uint8List _cacheMostRecentWay = Uint8List(
    _setCount,
  ); // which way was hit last (LRU bit)

  TValue? lookup(TKey key) {
    // pick a cache set by identity
    final set = identityHashCode(key) & _setMask;

    if (identical(_cacheWayAKey[set], key)) {
      _cacheMostRecentWay[set] = _wayA;
      return _cacheWayAValue[set];
    }
    if (identical(_cacheWayBKey[set], key)) {
      _cacheMostRecentWay[set] = _wayB;
      return _cacheWayBValue[set];
    }

    // cache miss: fall back to hash table
    final value = _tableLookup(key);

    if (_cacheMostRecentWay[set] == _wayA) {
      _cacheWayBKey[set] = key; // evict LRU (way B)
      _cacheWayBValue[set] = value;
      _cacheMostRecentWay[set] = _wayB;
    } else {
      _cacheWayAKey[set] = key; // evict LRU (way A)
      _cacheWayAValue[set] = value;
      _cacheMostRecentWay[set] = _wayA;
    }
    return value;
  }

  TValue? _tableLookup(TKey key) {
    // odd fingerprint; 0 marks empty slot
    final fingerprint = (key.hashCode & _hashMask) | _oddBit;
    var index = fingerprint & _slotMask;

    var candidate = _keys[index];
    if (candidate == null) return null;

    // compare fingerprint before full key
    if ((_fingerprints[index] >> _fingerprintShift) == fingerprint) {
      if (identical(candidate, key) || candidate == key) {
        return _values[index];
      }
    }

    while (true) {
      index = (index + 1) & _slotMask; // linear probe on collision

      candidate = _keys[index];
      if (candidate == null) return null;

      // compare fingerprint before full key
      if ((_fingerprints[index] >> _fingerprintShift) == fingerprint) {
        if (identical(candidate, key) || candidate == key) {
          return _values[index];
        }
      }
    }
  }

  void _insert(TKey key, TValue value) {
    final fingerprint = (key.hashCode & _hashMask) | _oddBit;
    var index = fingerprint & _slotMask;
    while (_keys[index] != null) {
      index = (index + 1) & _slotMask; // linear probe for a free slot
    }

    // store fingerprint in the high 32 bits
    _fingerprints[index] = fingerprint << _fingerprintShift;
    _keys[index] = key;
    _values[index] = value;
  }
}
