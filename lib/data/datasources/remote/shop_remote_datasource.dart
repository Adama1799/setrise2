// lib/data/datasources/remote/shop_remote_datasource.dart
import '../../../core/network/api_client.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/product_model.dart';

abstract class ShopRemoteDataSource {
  Future<List<ProductModel>> getProducts(int page, {String? category});
  Future<ProductModel> getProduct(String productId);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getFavoriteProducts();
  Future<ProductModel> addToFavorite(String productId);
  Future<ProductModel> removeFromFavorite(String productId);
  Future<List<String>> getCategories();
}

class ShopRemoteDataSourceImpl implements ShopRemoteDataSource {
  final ApiClient apiClient;

  ShopRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ProductModel>> getProducts(int page, {String? category}) async {
    try {
      String endpoint = '${ApiEndpoints.shopEndpoint}/products?page=$page&limit=${AppConstants.pageSize}';
      if (category != null) endpoint += '&category=$category';
      
      final response = await apiClient.get(endpoint);
      return (response as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> getProduct(String productId) async {
    try {
      final response = await apiClient.get('${ApiEndpoints.shopEndpoint}/products/$productId');
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await apiClient.get(
        '${ApiEndpoints.shopEndpoint}/products/search?q=$query',
      );
      return (response as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ProductModel>> getFavoriteProducts() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.shopEndpoint}/favorites');
      return (response as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> addToFavorite(String productId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.shopEndpoint}/products/$productId/favorite',
        {},
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ProductModel> removeFromFavorite(String productId) async {
    try {
      final response = await apiClient.post(
        '${ApiEndpoints.shopEndpoint}/products/$productId/unfavorite',
        {},
      );
      return ProductModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final response = await apiClient.get('${ApiEndpoints.shopEndpoint}/categories');
      return List<String>.from(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
