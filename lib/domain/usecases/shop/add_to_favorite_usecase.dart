// lib/domain/usecases/shop/add_to_favorite_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class AddToFavoriteUsecase {
  final ShopRepository repository;

  AddToFavoriteUsecase(this.repository);

  Future<Either<Failure, ProductEntity>> call(String productId) async {
    return repository.addToFavorite(productId);
  }
}
