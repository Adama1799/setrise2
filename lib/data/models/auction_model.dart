// lib/data/models/auction_model.dart

class AuctionModel {
  final String id;
  final String title;
  final double currentBid;
  final String imageUrl;
  final DateTime endTime;

  AuctionModel({
    required this.id,
    required this.title,
    required this.currentBid,
    required this.imageUrl,
    required this.endTime,
  });
}
