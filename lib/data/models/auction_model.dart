// lib/data/models/auction_model.dart
class AuctionModel {
  final String id;
  final String name;
  final double currentBid;
  final String imageUrl;
  final DateTime endTime;
  final int bidCount;

  AuctionModel({
    required this.id,
    required this.name,
    required this.currentBid,
    required this.imageUrl,
    required this.endTime,
    this.bidCount = 0,
  });

  String get formattedTimeLeft {
    final diff = endTime.difference(DateTime.now());
    if (diff.isNegative) return 'Ended';
    return '${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${diff.inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
