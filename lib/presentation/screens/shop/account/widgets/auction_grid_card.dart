// lib/presentation/screens/shop/auction/widgets/auction_grid_card.dart
import 'dart:async';
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../auction_item.dart';
import '../auction_detail_screen.dart';

class AuctionGridCard extends StatefulWidget {
  final AuctionItem auction;
  const AuctionGridCard({super.key, required this.auction});

  @override
  State<AuctionGridCard> createState() => _AuctionGridCardState();
}

class _AuctionGridCardState extends State<AuctionGridCard> {
  late Timer _timer;
  late Duration _rem;

  @override
  void initState() {
    super.initState();
    _rem = widget.auction.endTime.difference(DateTime.now());
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _rem = widget.auction.endTime.difference(DateTime.now())),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _fmt(Duration d) => d.isNegative
      ? 'Ended'
      : '${d.inHours}:${(d.inMinutes % 60).toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final ended = _rem.isNegative;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        CupertinoPageRoute(builder: (_) => AuctionDetailScreen(auction: widget.auction)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      widget.auction.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!ended)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.live,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.auction.name,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bid: \$${widget.auction.currentBid.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: AppColors.shop,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _fmt(_rem),
                    style: TextStyle(
                      color: ended ? AppColors.neonRed : AppColors.warning,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
