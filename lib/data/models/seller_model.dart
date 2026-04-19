// lib/data/models/seller_model.dart
class SellerModel {
  final String id;
  final String storeName;
  final String avatarUrl;
  final bool isVerified;
  final double rating;

  SellerModel({
    required this.id,
    required this.storeName,
    required this.avatarUrl,
    this.isVerified = false,
    this.rating = 4.5,
  });
}
