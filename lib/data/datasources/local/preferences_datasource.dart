// lib/data/datasources/local/preferences_datasource.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';

class PreferencesDataSource {
  final SharedPreferences _prefs;

  PreferencesDataSource(this._prefs);

  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  Future<void> saveList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  List<String>? getList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
