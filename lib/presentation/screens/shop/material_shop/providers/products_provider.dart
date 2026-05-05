import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

final productsProvider = FutureProvider<List<ProductModel>>((ref) async {
  await Future.delayed(const Duration(seconds: 1));
  return List.generate(
    20,
    (i) => ProductModel(
      id: 'prod_$i',
      name: 'SteelSeries Product ${i + 1}',
      brand: i % 2 == 0 ? 'SteelSeries' : 'OtherBrand',
      price: 49.99 + (i * 10),
      originalPrice: i % 3 == 0 ? 79.99 + (i * 10) : 0,
      discount: i % 3 == 0 ? 35 : 0,
      rating: 3.5 + (i % 3) * 0.7,
      reviewCount: 120 + (i * 10),
      images: ['https://picsum.photos/400/400?random=$i'],
      description: 'High quality product with excellent features.',
      isHot: i < 5,
      isNew: i >= 15,
      shippingFree: i % 2 == 0,
      stock: 10 + i,
    ),
  );
});
