// lib/data/mock_data/shop_mock_data.dart
import '../models/product_model.dart';
import '../models/category_model.dart';

class ShopMockData {
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: '1', name: 'Electronics', iconUrl: 'https://picsum.photos/200?random=1'),
      CategoryModel(id: '2', name: 'Fashion', iconUrl: 'https://picsum.photos/200?random=2'),
      CategoryModel(id: '3', name: 'Home', iconUrl: 'https://picsum.photos/200?random=3'),
      CategoryModel(id: '4', name: 'Beauty', iconUrl: 'https://picsum.photos/200?random=4'),
      CategoryModel(id: '5', name: 'Sports', iconUrl: 'https://picsum.photos/200?random=5'),
    ];
  }

  static List<ProductModel> getFeaturedProducts() {
    return List.generate(6, (index) => ProductModel(
      id: 'feat_$index',
      name: 'Wireless Headphones Pro $index',
      brandName: 'Brand X',
      categoryId: '1',
      description: 'High quality wireless headphones with noise cancellation.',
      price: 129.99 + (index * 10),
      oldPrice: index % 2 == 0 ? 199.99 : null,
      rating: 4.5 + (index % 3) * 0.1,
      reviewsCount: 1240 + (index * 50),
      stock: 15,
      images: ['https://picsum.photos/400/400?random=${index + 100}'],
      sizes: ['S', 'M', 'L'],
      colors: ['Black', 'White', 'Blue'],
      isFeatured: true,
    ));
  }

  static List<ProductModel> getPopularProducts() {
    return List.generate(8, (index) => ProductModel(
      id: 'pop_$index',
      name: 'Smart Watch Series $index',
      brandName: 'TechFit',
      categoryId: '1',
      description: 'Fitness tracker with heart rate monitor.',
      price: 89.99 + (index * 5),
      oldPrice: index % 3 == 0 ? 129.99 : null,
      rating: 4.2 + (index % 5) * 0.15,
      reviewsCount: 890 + (index * 30),
      stock: 8,
      images: ['https://picsum.photos/400/400?random=${index + 200}'],
      sizes: ['One Size'],
      colors: ['Silver', 'Rose Gold'],
    ));
  }

  static List<ProductModel> getProductsForCategory(String categoryId) {
    // Return different products based on category
    return List.generate(10, (index) => ProductModel(
      id: 'cat_${categoryId}_$index',
      name: 'Product $index',
      brandName: 'Brand',
      categoryId: categoryId,
      description: 'Description for product $index',
      price: 49.99 + (index * 7),
      oldPrice: index % 4 == 0 ? 79.99 : null,
      rating: 4.0 + (index % 10) * 0.1,
      reviewsCount: 200 + (index * 20),
      stock: 5,
      images: ['https://picsum.photos/400/400?random=${index + 300}'],
      sizes: ['Standard'],
      colors: ['Various'],
    ));
  }

  static List<String> getBannerImages() {
    return [
      'https://picsum.photos/800/300?random=101',
      'https://picsum.photos/800/300?random=102',
      'https://picsum.photos/800/300?random=103',
    ];
  }
}
