import 'dart:convert';
import 'dart:developer' as developer;

/// Simple in-memory cache service with TTL (Time-To-Live)
class CacheService {
  static final CacheService instance = CacheService._internal();
  CacheService._internal();

  final Map<String, _CacheEntry> _cache = {};

  /// Store value in cache with optional TTL (default 5 minutes)
  void set(String key, dynamic value, {Duration? ttl}) {
    final expiry = DateTime.now().add(ttl ?? const Duration(minutes: 5));
    _cache[key] = _CacheEntry(value: value, expiry: expiry);

    developer.log(
      'Cache SET: $key (expires in ${ttl?.inMinutes ?? 5}m)',
      name: 'CacheService',
    );
  }

  /// Get value from cache, returns null if expired or not found
  T? get<T>(String key) {
    final entry = _cache[key];

    if (entry == null) {
      developer.log('Cache MISS: $key', name: 'CacheService');
      return null;
    }

    // Check if expired
    if (DateTime.now().isAfter(entry.expiry)) {
      developer.log('Cache EXPIRED: $key', name: 'CacheService');
      _cache.remove(key);
      return null;
    }

    developer.log('Cache HIT: $key', name: 'CacheService');
    return entry.value as T;
  }

  /// Check if cache has valid (non-expired) entry for key
  bool has(String key) {
    final entry = _cache[key];
    if (entry == null) return false;

    if (DateTime.now().isAfter(entry.expiry)) {
      _cache.remove(key);
      return false;
    }

    return true;
  }

  /// Remove specific key from cache
  void remove(String key) {
    _cache.remove(key);
    developer.log('Cache REMOVE: $key', name: 'CacheService');
  }

  /// Clear all cache entries
  void clear() {
    _cache.clear();
    developer.log('Cache CLEARED', name: 'CacheService');
  }

  /// Clear expired entries
  void clearExpired() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) => now.isAfter(entry.expiry));
    developer.log('Cache expired entries cleared', name: 'CacheService');
  }

  /// Generate cache key from map of parameters
  static String generateKey(String prefix, Map<String, dynamic> params) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final paramsString = jsonEncode(sortedParams);
    return '$prefix:$paramsString';
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    final validEntries =
        _cache.entries.where((e) => now.isBefore(e.value.expiry));

    return {
      'totalEntries': _cache.length,
      'validEntries': validEntries.length,
      'expiredEntries': _cache.length - validEntries.length,
    };
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime expiry;

  _CacheEntry({required this.value, required this.expiry});
}
