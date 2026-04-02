// lib/domain/usecases/shop/get_categories_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/shop_repository.dart';
import '../../../core/errors/failures.dart';

class GetCategoriesUsecase {
  final ShopRepository repository;

  GetCategoriesUsecase(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return repository.getCategories();
  }
}
