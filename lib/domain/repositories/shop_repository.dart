// lib/domain/repositories/shop_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/product_entity.dart';
import '../../core/errors/failures.dart';

abstract class ShopRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts(int page, {String? category});
  Future<Either<Failure, ProductEntity>> getProduct(String productId);
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query);
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts();
  Future<Either<Failure, ProductEntity>> addToFavorite(String productId);
  Future<Either<Failure, ProductEntity>> removeFromFavorite(String productId);
  Future<Either<Failure, List<String>>> getCategories();
}
