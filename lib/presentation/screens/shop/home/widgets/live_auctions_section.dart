import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../auction/auction_item.dart';
import '../../auction/widgets/auction_grid_card.dart';

class LiveAuctionsSection extends StatelessWidget {
  const LiveAuctionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final auctions = AuctionItem.getMockAuctions().take(3).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Live Auctions', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          CupertinoButton(padding: EdgeInsets.zero, child: const Text('View All', style: TextStyle(color: AppColors.shop)), onPressed: () {}),
        ]),
      ),
      SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: auctions.length,
          itemBuilder: (_, i) => SizedBox(width: 160, child: Padding(padding: const EdgeInsets.all(8), child: AuctionGridCard(auction: auctions[i]))),
        ),
      ),
    ]);
  }
}
