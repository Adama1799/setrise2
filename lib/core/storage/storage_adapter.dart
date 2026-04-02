// lib/core/storage/storage_adapter.dart
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import '../utils/universal_platform.dart';
import 'dart:io';

class StorageAdapter {
  static Future<void> initStorage() async {
    if (UniversalPlatform.isWeb) {
      // Web uses IndexedDB
      Hive.init('setrise_db');
    } else {
      // Mobile and Desktop
      final appDocDir = await getApplicationDocumentsDirectory();
      Hive.init(appDocDir.path);
    }
  }

  static Future<String> getStoragePath() async {
    if (UniversalPlatform.isWeb) {
      return 'setrise_db';
    }
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  static Future<void> clearStorage() async {
    await Hive.deleteFromDisk();
  }
}
