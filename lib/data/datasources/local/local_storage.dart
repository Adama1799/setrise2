import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Local storage abstraction
abstract class LocalStorage {
  // String operations
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  
  // Int operations
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  
  // Bool operations
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  
  // Double operations
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  
  // Object operations (JSON)
  Future<void> setObject(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getObject(String key);
  
  // List operations
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  
  // Remove operations
  Future<void> remove(String key);
  Future<void> clear();
  
  // Check if key exists
  Future<bool> containsKey(String key);
  
  // Get all keys
  Future<Set<String>> getKeys();
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _prefs;
  Box? _hiveBox;

  LocalStorageImpl(this._prefs);

  /// Initialize Hive box for complex objects
  Future<void> _initHive() async {
    if (_hiveBox == null || !_hiveBox!.isOpen) {
      _hiveBox = await Hive.openBox('app_storage');
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  @override
  Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = json.encode(value);
    await _prefs.setString(key, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;
    
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    await _prefs.remove(key);
    
    // Also remove from Hive if exists
    await _initHive();
    if (_hiveBox!.containsKey(key)) {
      await _hiveBox!.delete(key);
    }
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
    
    // Also clear Hive
    await _initHive();
    await _hiveBox!.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<Set<String>> getKeys() async {
    return _prefs.getKeys();
  }

  // ==================== Hive-specific operations ====================
  
  /// Save complex object using Hive
  Future<void> saveComplexObject<T>(String key, T value) async {
    await _initHive();
    await _hiveBox!.put(key, value);
  }

  /// Get complex object using Hive
  Future<T?> getComplexObject<T>(String key) async {
    await _initHive();
    return _hiveBox!.get(key) as T?;
  }

  /// Save list of complex objects
  Future<void> saveComplexList<T>(String key, List<T> value) async {
    await _initHive();
    await _hiveBox!.put(key, value);
  }

  /// Get list of complex objects
  Future<List<T>?> getComplexList<T>(String key) async {
    await _initHive();
    final data = _hiveBox!.get(key);
    if (data == null) return null;
    return (data as List).cast<T>();
  }

  /// Get all values from Hive
  Future<Map<String, dynamic>> getAllHiveData() async {
    await _initHive();
    return Map<String, dynamic>.from(_hiveBox!.toMap());
  }

  /// Close Hive box
  Future<void> closeHive() async {
    if (_hiveBox != null && _hiveBox!.isOpen) {
      await _hiveBox!.close();
    }
  }
}
