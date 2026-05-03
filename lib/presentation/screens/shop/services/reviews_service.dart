// lib/presentation/screens/shop/services/reviews_service.dart
import 'dart:async';
import 'package:setrise/presentation/screens/shop/models/review_model.dart';

class ReviewsService {
  static final ReviewsService _instance = ReviewsService._();
  factory ReviewsService() => _instance;
  ReviewsService._();

  final Map<String, List<ReviewModel>> _reviewsByProduct = {};

  List<ReviewModel> getReviewsForProduct(String productId) {
    return _reviewsByProduct[productId] ?? [];
  }

  void addReview(String productId, ReviewModel review) {
    _reviewsByProduct.putIfAbsent(productId, () => []);
    _reviewsByProduct[productId]!.insert(0, review);
  }
}
