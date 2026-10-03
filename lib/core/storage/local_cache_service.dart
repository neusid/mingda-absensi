import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mingda_app/core/storage/hive_constants.dart';

abstract class LocalCacheService {
  Future<void> init();
  Future<void> put(String key, dynamic value);
  dynamic get(String key);
  Map<String, dynamic>? getMap(String key);
  List<Map<String, dynamic>>? getMapList(String key);
  Future<void> delete(String key);
  Future<void> clearCache();
}

class LocalCacheServiceImpl implements LocalCacheService {
  Box? _cacheBox;

  Box? get cacheBox {
    if (_cacheBox != null && _cacheBox!.isOpen) {
      return _cacheBox;
    }
    if (Hive.isBoxOpen(HiveConstants.cacheBoxName)) {
      _cacheBox = Hive.box(HiveConstants.cacheBoxName);
      return _cacheBox;
    }
    return null;
  }

  @override
  Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(HiveConstants.cacheBoxName)) {
        _cacheBox = await Hive.openBox(HiveConstants.cacheBoxName);
      } else {
        _cacheBox = Hive.box(HiveConstants.cacheBoxName);
      }
    } catch (e) {
      debugPrint('Error opening Hive cache box: $e');
    }
  }

  @override
  Future<void> put(String key, dynamic value) async {
    try {
      final box = cacheBox;
      if (box == null) return;
      if (value is Map || value is List) {
        await box.put(key, jsonEncode(value));
      } else {
        await box.put(key, value);
      }
    } catch (e) {
      debugPrint('Error writing to cache: $e');
    }
  }

  @override
  dynamic get(String key) {
    try {
      final box = cacheBox;
      if (box == null) return null;
      return box.get(key);
    } catch (e) {
      debugPrint('Error reading from cache: $e');
      return null;
    }
  }

  @override
  Map<String, dynamic>? getMap(String key) {
    try {
      final box = cacheBox;
      if (box == null) return null;
      final raw = box.get(key);
      if (raw == null) return null;
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error decoding map from cache ($key): $e');
      return null;
    }
  }

  @override
  List<Map<String, dynamic>>? getMapList(String key) {
    try {
      final box = cacheBox;
      if (box == null) return null;
      final raw = box.get(key);
      if (raw == null) return null;
      if (raw is List) {
        return raw.map((item) => Map<String, dynamic>.from(item as Map)).toList();
      }
      if (raw is String) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded.map((item) => Map<String, dynamic>.from(item as Map)).toList();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error decoding map list from cache ($key): $e');
      return null;
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      final box = cacheBox;
      if (box == null) return;
      await box.delete(key);
    } catch (e) {
      debugPrint('Error deleting from cache: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = cacheBox;
      if (box == null) return;
      await box.clear();
    } catch (e) {
      debugPrint('Error clearing cache box: $e');
    }
  }
}
