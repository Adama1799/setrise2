// lib/data/models/seller_model.dart

class SellerModel {
  final String id;
  final String name;
  final String avatar;
  final bool isVerified;

  SellerModel({
    required this.id,
    required this.name,
    required this.avatar,
    this.isVerified = false,
  });
}
