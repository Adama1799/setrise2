// lib/core/storage/storage_adapter.dart
// BUG FIX: Was importing 'dart:io' which crashes on Web platform
//           Also Hive.init() on web needs to use hive_flutter's initFlutter()
import 'package:hive_flutter/hive_flutter.dart'; // ✅ handles web + mobile
import '../utils/logger.dart';

class StorageAdapter {
  static Future<void> initStorage() async {
    // ✅ hive_flutter's initFlutter() handles both web (IndexedDB) and mobile (filesystem)
    await Hive.initFlutter();
    Logger.log('✅ Storage initialized');
  }

  static Future<void> clearStorage() async {
    try {
      await Hive.deleteFromDisk();
    } catch (e) {
      Logger.error('Failed to clear storage: $e');
    }
  }

  static Future<Box<T>> openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
    return await Hive.openBox<T>(name);
  }
}
