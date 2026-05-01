// lib/presentation/screens/shop/auction/auction_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import 'auction_item.dart';
import 'widgets/auction_grid_card.dart';

class AuctionScreen extends StatefulWidget {
  const AuctionScreen({super.key});
  @override
  State<AuctionScreen> createState() => _AuctionScreenState();
}

class _AuctionScreenState extends State<AuctionScreen> {
  final List<AuctionItem> _auctions = AuctionItem.getMockAuctions();
  String _filter = 'All';
  final _filters = ['All', 'Live', 'Ending Soon'];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: AppColors.surface,
        middle: Text('Live Auctions', style: TextStyle(color: AppColors.white)),
      ),
      child: SafeArea(
        child: Column(children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (_, i) {
                final cat = _filters[i];
                final sel = _filter == cat;
                return GestureDetector(
                  onTap: () => setState(() => _filter = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: sel ? AppColors.shop : AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Text(cat, style: TextStyle(color: sel ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 12, mainAxisSpacing: 16),
              itemCount: _auctions.length,
              itemBuilder: (_, i) => AuctionGridCard(auction: _auctions[i]),
            ),
          ),
        ]),
      ),
    );
  }
}
