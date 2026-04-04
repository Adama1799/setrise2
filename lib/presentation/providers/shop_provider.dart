// lib/presentation/providers/shop_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/service_locator.dart';
import '../../domain/usecases/shop/get_products_usecase.dart';
import '../../domain/usecases/shop/get_categories_usecase.dart';
import '../../domain/usecases/shop/get_favorite_products_usecase.dart';
import '../../domain/usecases/shop/add_to_favorite_usecase.dart';
import '../../data/models/product_model.dart';

final shopProvider = StateNotifierProvider<ShopNotifier, ShopState>((ref) {
  return ShopNotifier();
});

class ShopState {
  final List<ProductModel> products;
  final List<ProductModel> favoriteProducts;
  final List<String> categories;
  final bool isLoading;
  final bool isLoadingCategories;
  final String? error;
  final int currentPage;
  final bool hasMoreProducts;
  final String? selectedCategory;

  ShopState({
    required this.products,
    required this.favoriteProducts,
    required this.categories,
    required this.isLoading,
    required this.isLoadingCategories,
    this.error,
    required this.currentPage,
    required this.hasMoreProducts,
    this.selectedCategory,
  });

  ShopState copyWith({
    List<ProductModel>? products,
    List<ProductModel>? favoriteProducts,
    List<String>? categories,
    bool? isLoading,
    bool? isLoadingCategories,
    String? error,
    int? currentPage,
    bool? hasMoreProducts,
    String? selectedCategory,
  }) {
    return ShopState(
      products: products ?? this.products,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMoreProducts: hasMoreProducts ?? this.hasMoreProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class ShopNotifier extends StateNotifier<ShopState> {
  final _getProductsUsecase = getIt<GetProductsUsecase>();
  final _getCategoriesUsecase = getIt<GetCategoriesUsecase>();
  final _getFavoriteProductsUsecase = getIt<GetFavoriteProductsUsecase>();
  final _addToFavoriteUsecase = getIt<AddToFavoriteUsecase>();

  ShopNotifier()
      : super(ShopState(
          products: _generateMockProducts(),
          favoriteProducts: [],
          categories: [],
          isLoading: false,
          isLoadingCategories: false,
          currentPage: 0,
          hasMoreProducts: true,
        ));

  static List<ProductModel> _generateMockProducts() {
    return List.generate(10, (i) => ProductModel(
      id: '$i',
      name: 'Product ${i + 1}',
      description: 'Amazing product description',
      price: (i + 1) * 29.99,
      originalPrice: (i + 1) * 49.99,
      images: ['https://via.placeholder.com/300?text=Product+${i + 1}'],
      rating: 4.5,
      reviewsCount: (i + 1) * 100,
      stock: 50,
      isFavorite: false,
      category: 'Electronics',
      onSale: i % 2 == 0,
      discount: i % 2 == 0 ? 40 : 0,
    ));
  }

  Future<void> loadProducts(int page, {String? category}) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedCategory: category,
    );
    final result = await _getProductsUsecase(
      state.currentPage,
      category: category,
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (products) {
        state = state.copyWith(
          products: products.cast<ProductModel>(),
          isLoading: false,
          hasMoreProducts: products.length >= 20,
        );
      },
    );
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoadingCategories: true);
    final result = await _getCategoriesUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoadingCategories: false,
          error: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          categories: categories,
          isLoadingCategories: false,
        );
      },
    );
  }

  void toggleFavorite(String productId) async {
    final product = state.products.firstWhere((p) => p.id == productId);
    if (!product.isFavorite) {
      final result = await _addToFavoriteUsecase(productId);
      result.fold(
        (failure) {},
        (updatedProduct) {
          final index = state.products.indexWhere((p) => p.id == productId);
          final updatedProducts = [...state.products];
          updatedProducts[index] = updatedProduct as ProductModel;
          state = state.copyWith(products: updatedProducts);
        },
      );
    }
  }

  Future<void> loadFavoriteProducts() async {
    state = state.copyWith(isLoading: true);
    final result = await _getFavoriteProductsUsecase();
    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (products) {
        state = state.copyWith(
          favoriteProducts: products.cast<ProductModel>(),
          isLoading: false,
        );
      },
    );
  }
}
