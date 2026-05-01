// lib/presentation/screens/shop/auction/widgets/auction_timer_card.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class AuctionTimerCard extends StatelessWidget {
  final String timeLeft;
  final bool isEnded;
  const AuctionTimerCard({super.key, required this.timeLeft, required this.isEnded});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Icon(CupertinoIcons.timer, color: isEnded ? AppColors.neonRed : AppColors.warning, size: 32),
        const SizedBox(width: 16),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Time Left', style: TextStyle(color: AppColors.grey2, fontSize: 13)),
          Text(timeLeft, style: TextStyle(color: isEnded ? AppColors.neonRed : AppColors.warning, fontSize: 24, fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }
}
