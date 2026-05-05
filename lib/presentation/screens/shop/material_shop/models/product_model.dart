class ProductModel {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double originalPrice;
  final int discount;
  final double rating;
  final int reviewCount;
  final List<String> images;
  final String? description;
  final Map<String, String> specs;
  final bool isHot;
  final bool isNew;
  final bool shippingFree;
  final int stock;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.originalPrice = 0,
    this.discount = 0,
    this.rating = 0,
    this.reviewCount = 0,
    this.images = const [],
    this.description,
    this.specs = const {},
    this.isHot = false,
    this.isNew = false,
    this.shippingFree = false,
    this.stock = 0,
  });
}
