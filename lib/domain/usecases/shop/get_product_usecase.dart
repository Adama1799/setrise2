// lib/domain/usecases/shop/get_product_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class GetProductUsecase {
  final ShopRepository repository;

  GetProductUsecase(this.repository);

  Future<Either<Failure, ProductEntity>> call(String productId) async {
    return repository.getProduct(productId);
  }
}
