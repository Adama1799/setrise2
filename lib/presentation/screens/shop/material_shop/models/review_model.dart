// material_shop/models/review_model.dart
class ReviewModel {
  final String id, productId, userName, comment;
  final double rating;
  final String? imageUrl;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.productId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.imageUrl,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}
