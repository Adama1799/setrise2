// lib/presentation/screens/shop/account/offers_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupons = [
      {'code': 'WELCOME10', 'desc': '10% off your first order'},
      {'code': 'SAVE50', 'desc': '\$50 off orders over \$200'},
    ];
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(middle: Text('Coupons & Offers', style: TextStyle(color: CupertinoColors.white))),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: coupons.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.shop.withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(CupertinoIcons.ticket, color: AppColors.shop)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(coupons[i]['code']!, style: const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.bold)),
              Text(coupons[i]['desc']!, style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
            ])),
            CupertinoButton(padding: EdgeInsets.zero, child: const Text('Claim', style: TextStyle(color: AppColors.shop)), onPressed: () {}),
          ]),
        ),
      ),
    );
  }
}
