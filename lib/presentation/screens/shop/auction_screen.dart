// lib/presentation/screens/shop/auction_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});

  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  final List<AuctionItem> _auctions = AuctionItem.getMockAuctions();
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Live', 'Ending Soon', 'New'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Live Auctions',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Category chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.shop
                          : AppColors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: isSelected ? AppColors.black : AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Auctions grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: _auctions.length,
              itemBuilder: (context, index) {
                return _AuctionCard(auction: _auctions[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AuctionCard extends StatefulWidget {
  final AuctionItem auction;

  const _AuctionCard({required this.auction});

  @override
  State<_AuctionCard> createState() => _AuctionCardState();
}

class _AuctionCardState extends State<_AuctionCard> {
  late Timer _timer;
  late Duration _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.auction.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime = widget.auction.endTime.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Ended';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final isEnded = _remainingTime.isNegative;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AuctionDetailScreen(auction: widget.auction),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.grey,
                      child: Image.network(
                        widget.auction.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grey,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.grey2,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Live badge
                  if (!isEnded)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.live,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'LIVE',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.auction.name,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current Bid',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.grey2,
                      ),
                    ),
                    Text(
                      '\$${widget.auction.currentBid.toStringAsFixed(2)}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.shop,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          color: AppColors.grey2,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDuration(_remainingTime),
                          style: AppTextStyles.caption.copyWith(
                            color: isEnded ? AppColors.neonRed : AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${widget.auction.bidCount} bids',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== AUCTION DETAIL SCREEN =====
class AuctionDetailScreen extends StatefulWidget {
  final AuctionItem auction;

  const AuctionDetailScreen({super.key, required this.auction});

  @override
  State<AuctionDetailScreen> createState() => _AuctionDetailScreenState();
}

class _AuctionDetailScreenState extends State<AuctionDetailScreen> {
  final TextEditingController _bidController = TextEditingController();
  late Timer _timer;
  late Duration _remainingTime;
  double _currentBid = 0;

  @override
  void initState() {
    super.initState();
    _currentBid = widget.auction.currentBid;
    _remainingTime = widget.auction.endTime.difference(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _remainingTime = widget.auction.endTime.difference(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bidController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return 'Auction Ended';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  void _placeBid() {
    final bid = double.tryParse(_bidController.text);
    if (bid == null || bid <= _currentBid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bid must be higher than \$${_currentBid.toStringAsFixed(2)}'),
          backgroundColor: AppColors.neonRed,
        ),
      );
      return;
    }
    setState(() {
      _currentBid = bid;
      widget.auction.bidCount++;
    });
    _bidController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bid placed! You are now the highest bidder.'),
        backgroundColor: AppColors.neonGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnded = _remainingTime.isNegative;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Auction Details',
          style: AppTextStyles.h5.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                height: 250,
                width: double.infinity,
                color: AppColors.grey,
                child: Image.network(
                  widget.auction.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.grey,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: AppColors.grey2,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Title
            Text(
              widget.auction.name,
              style: AppTextStyles.h5.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.auction.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey2,
              ),
            ),
            const SizedBox(height: 20),
            // Timer card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.warning,
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time Remaining',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                      Text(
                        _formatDuration(_remainingTime),
                        style: AppTextStyles.h4.copyWith(
                          color: isEnded ? AppColors.neonRed : AppColors.warning,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Bid info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.grey.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Bid',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                      Text(
                        '\$${_currentBid.toStringAsFixed(2)}',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.shop,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Bids',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.grey2,
                        ),
                      ),
                      Text(
                        '${widget.auction.bidCount}',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Starting bid info
            Text(
              'Starting bid: \$${widget.auction.startingBid.toStringAsFixed(2)}',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Min bid increment: \$1.00',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.grey2,
              ),
            ),
            const SizedBox(height: 24),
            // Bid input
            if (!isEnded) ...[
              Text(
                'Place Your Bid',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _bidController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white,
                      ),
                      decoration: InputDecoration(
                        prefixText: '\$ ',
                        prefixStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.white,
                        ),
                        hintText: 'Enter bid amount',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey2,
                        ),
                        filled: true,
                        fillColor: AppColors.grey.withOpacity(0.1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _placeBid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.shop,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Place Bid',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neonRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppColors.neonRed,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'This auction has ended',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.neonRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ===== AUCTION MODEL =====
class AuctionItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
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

  static List<AuctionItem> getMockAuctions() {
    return [
      AuctionItem(
        id: '1',
        name: 'Vintage Rolex Submariner',
        description: 'Authentic vintage Rolex Submariner from 1985. Excellent condition.',
        imageUrl: 'https://picsum.photos/400/400?random=201',
        startingBid: 5000,
        currentBid: 6750,
        bidCount: 23,
        endTime: DateTime.now().add(const Duration(hours: 2, minutes: 30)),
      ),
      AuctionItem(
        id: '2',
        name: 'iPhone 15 Pro Max',
        description: 'Brand new, sealed in box. 256GB, Natural Titanium.',
        imageUrl: 'https://picsum.photos/400/400?random=202',
        startingBid: 800,
        currentBid: 1050,
        bidCount: 15,
        endTime: DateTime.now().add(const Duration(hours: 5, minutes: 45)),
      ),
      AuctionItem(
        id: '3',
        name: 'Sony PlayStation 5',
        description: 'PS5 Disc Edition with 2 controllers and 3 games.',
        imageUrl: 'https://picsum.photos/400/400?random=203',
        startingBid: 350,
        currentBid: 420,
        bidCount: 8,
        endTime: DateTime.now().add(const Duration(minutes: 45)),
      ),
      AuctionItem(
        id: '4',
        name: 'Nike Air Jordan 1 Retro',
        description: 'Deadstock, size 10. Chicago colorway.',
        imageUrl: 'https://picsum.photos/400/400?random=204',
        startingBid: 200,
        currentBid: 380,
        bidCount: 31,
        endTime: DateTime.now().add(const Duration(hours: 8)),
      ),
      AuctionItem(
        id: '5',
        name: 'MacBook Pro M3 Max',
        description: '14-inch, 36GB RAM, 1TB SSD. Like new condition.',
        imageUrl: 'https://picsum.photos/400/400?random=205',
        startingBid: 2000,
        currentBid: 2450,
        bidCount: 12,
        endTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
      ),
      AuctionItem(
        id: '6',
        name: 'Louis Vuitton Neverfull MM',
        description: 'Authentic, excellent condition. Includes dust bag.',
        imageUrl: 'https://picsum.photos/400/400?random=206',
        startingBid: 800,
        currentBid: 950,
        bidCount: 6,
        endTime: DateTime.now().add(const Duration(hours: 12)),
      ),
    ];
  }
}
