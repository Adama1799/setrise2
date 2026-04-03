// lib/data/repositories/shop_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../datasources/remote/shop_remote_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(int page, {String? category}) async {
    try {
      final products = await remoteDataSource.getProducts(page, category: category);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProduct(String productId) async {
    try {
      final product = await remoteDataSource.getProduct(productId);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> searchProducts(String query) async {
    try {
      final products = await remoteDataSource.searchProducts(query);
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFavoriteProducts() async {
    try {
      final products = await remoteDataSource.getFavoriteProducts();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> addToFavorite(String productId) async {
    try {
      final product = await remoteDataSource.addToFavorite(productId);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> removeFromFavorite(String productId) async {
    try {
      final product = await remoteDataSource.removeFromFavorite(productId);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();
      return Right(categories);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
