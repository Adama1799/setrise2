// lib/data/datasources/local/local_cache_datasource.dart
import 'package:hive/hive.dart';
import '../../../core/errors/exceptions.dart';

abstract class LocalCacheDataSource {
  Future<void> cachePosts(List<Map<String, dynamic>> posts);
  Future<List<Map<String, dynamic>>> getCachedPosts();
  Future<void> cacheThreads(List<Map<String, dynamic>> threads);
  Future<List<Map<String, dynamic>>> getCachedThreads();
  Future<void> cacheProducts(List<Map<String, dynamic>> products);
  Future<List<Map<String, dynamic>>> getCachedProducts();
  Future<void> clearCache();
}

class LocalCacheDataSourceImpl implements LocalCacheDataSource {
  static const String postsBox = 'posts_cache';
  static const String threadsBox = 'threads_cache';
  static const String productsBox = 'products_cache';

  @override
  Future<void> cachePosts(List<Map<String, dynamic>> posts) async {
    try {
      final box = await Hive.openBox<List>(postsBox);
      await box.put('posts', posts);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedPosts() async {
    try {
      final box = await Hive.openBox<List>(postsBox);
      final posts = box.get('posts', defaultValue: []);
      return posts?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheThreads(List<Map<String, dynamic>> threads) async {
    try {
      final box = await Hive.openBox<List>(threadsBox);
      await box.put('threads', threads);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedThreads() async {
    try {
      final box = await Hive.openBox<List>(threadsBox);
      final threads = box.get('threads', defaultValue: []);
      return threads?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> cacheProducts(List<Map<String, dynamic>> products) async {
    try {
      final box = await Hive.openBox<List>(productsBox);
      await box.put('products', products);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCachedProducts() async {
    try {
      final box = await Hive.openBox<List>(productsBox);
      final products = box.get('products', defaultValue: []);
      return products?.cast<Map<String, dynamic>>() ?? [];
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Hive.deleteBoxFromDisk(postsBox);
      await Hive.deleteBoxFromDisk(threadsBox);
      await Hive.deleteBoxFromDisk(productsBox);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }
}
