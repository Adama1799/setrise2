// lib/domain/usecases/shop/get_products_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class GetProductsUsecase {
  final ShopRepository repository;

  GetProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(
    int page, {
    String? category,
  }) async {
    return repository.getProducts(page, category: category);
  }
}
