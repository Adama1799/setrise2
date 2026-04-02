// lib/domain/usecases/shop/get_favorite_products_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class GetFavoriteProductsUsecase {
  final ShopRepository repository;

  GetFavoriteProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call() async {
    return repository.getFavoriteProducts();
  }
}
