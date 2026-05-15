import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/review_model.dart';

class ReviewsNotifier extends StateNotifier<List<ReviewModel>> {
  ReviewsNotifier() : super(_seed);

  void addReview(ReviewModel review) {
    state = [review, ...state];
  }

  List<ReviewModel> forProduct(String productId) =>
      state.where((r) => r.productId == productId).toList();

  double averageRating(String productId) {
    final reviews = forProduct(productId);
    if (reviews.isEmpty) return 0;
    return reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;
  }
}

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, List<ReviewModel>>(
        (_) => ReviewsNotifier());

// ─── Seed data ───────────────────────────────────────────────
final _seed = [
  ReviewModel(id: 'r1', productId: 'prod_0', userName: 'Ahmed K.',  rating: 5, comment: 'Absolutely love this product! Build quality is top notch.',     date: DateTime.now().subtract(const Duration(days: 2))),
  ReviewModel(id: 'r2', productId: 'prod_0', userName: 'Sara M.',   rating: 4, comment: 'Great value for money, fast shipping too.',                      date: DateTime.now().subtract(const Duration(days: 5))),
  ReviewModel(id: 'r3', productId: 'prod_1', userName: 'Omar T.',   rating: 3, comment: 'Decent product but packaging could be better.',                  date: DateTime.now().subtract(const Duration(days: 8))),
  ReviewModel(id: 'r4', productId: 'prod_2', userName: 'Lina R.',   rating: 5, comment: 'Exceeded my expectations. Will buy again!',                      date: DateTime.now().subtract(const Duration(days: 1))),
  ReviewModel(id: 'r5', productId: 'prod_3', userName: 'Khalid S.', rating: 4, comment: 'Very good quality. Arrived quickly and well packaged.',          date: DateTime.now().subtract(const Duration(days: 3))),
];
