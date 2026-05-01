// lib/presentation/screens/shop/auction/auction_item.dart
class AuctionItem {
  final String id, name, description, imageUrl;
  final double startingBid;
  double currentBid;
  int bidCount;
  final DateTime endTime;

  AuctionItem({required this.id, required this.name, required this.description, required this.imageUrl, required this.startingBid, required this.currentBid, required this.bidCount, required this.endTime});

  static List<AuctionItem> getMockAuctions() => [
    AuctionItem(id: '1', name: 'Rolex Submariner', description: 'Authentic vintage Rolex from 1985.', imageUrl: 'https://picsum.photos/400/400?random=201', startingBid: 5000, currentBid: 6750, bidCount: 23, endTime: DateTime.now().add(const Duration(hours: 2))),
    AuctionItem(id: '2', name: 'iPhone 15 Pro Max', description: 'Brand new, sealed.', imageUrl: 'https://picsum.photos/400/400?random=202', startingBid: 800, currentBid: 1050, bidCount: 15, endTime: DateTime.now().add(const Duration(hours: 5))),
    AuctionItem(id: '3', name: 'PS5 Disc Edition', description: 'With 2 controllers and 3 games.', imageUrl: 'https://picsum.photos/400/400?random=203', startingBid: 350, currentBid: 420, bidCount: 8, endTime: DateTime.now().add(const Duration(minutes: 45))),
  ];
}
