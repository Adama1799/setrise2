// lib/presentation/screens/shop/account/saved_cards_screen.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';

class SavedCardsScreen extends StatelessWidget {
  const SavedCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Payment Methods', style: TextStyle(color: CupertinoColors.white)),
        trailing: Icon(CupertinoIcons.add, color: AppColors.shop),
      ),
      child: ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(width: 40, height: 25, decoration: BoxDecoration(color: CupertinoColors.systemBlue, borderRadius: BorderRadius.circular(4)), child: const Center(child: Text('VISA', style: TextStyle(color: CupertinoColors.white, fontSize: 10)))),
            const SizedBox(width: 16),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('**** 4242', style: TextStyle(color: CupertinoColors.white)),
              Text('Expires 12/27', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 13)),
            ])),
            const Icon(CupertinoIcons.check_mark_circled, color: CupertinoColors.activeGreen),
          ]),
        ),
      ]),
    );
  }
}
