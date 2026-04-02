// lib/domain/usecases/shop/search_products_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/product_entity.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class SearchProductsUsecase {
  final ShopRepository repository;

  SearchProductsUsecase(this.repository);

  Future<Either<Failure, List<ProductEntity>>> call(String query) async {
    return repository.searchProducts(query);
  }
}
