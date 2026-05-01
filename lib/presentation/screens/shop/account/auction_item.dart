class AuctionItem {
  final String id, name, description, imageUrl;
  final double startingBid;
  double currentBid;
  int bidCount;
  final DateTime endTime;

  AuctionItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.startingBid,
    required this.currentBid,
    required this.bidCount,
    required this.endTime,
  });

  static List<AuctionItem> getMockAuctions() => [
    AuctionItem(id: '1', name: 'Rolex Submariner', description: 'Vintage Rolex', imageUrl: 'https://picsum.photos/400/400?random=201', startingBid: 5000, currentBid: 6750, bidCount: 23, endTime: DateTime.now().add(const Duration(hours: 2))),
    AuctionItem(id: '2', name: 'iPhone 15 Pro', description: 'New sealed', imageUrl: 'https://picsum.photos/400/400?random=202', startingBid: 800, currentBid: 1050, bidCount: 15, endTime: DateTime.now().add(const Duration(hours: 5))),
    AuctionItem(id: '3', name: 'PS5', description: 'Console', imageUrl: 'https://picsum.photos/400/400?random=203', startingBid: 350, currentBid: 420, bidCount: 8, endTime: DateTime.now().add(const Duration(minutes: 45))),
  ];
}
