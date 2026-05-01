// lib/presentation/screens/shop/marketplace/widgets/store_card.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models/store_model.dart';
import '../store_profile_screen.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => StoreProfileScreen(store: store))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(store.logoUrl, width: 70, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(store.name, style: const TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(store.description, style: const TextStyle(color: AppColors.grey2, fontSize: 13)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(CupertinoIcons.star_fill, color: CupertinoColors.systemYellow, size: 14),
                const SizedBox(width: 4),
                Text(store.rating.toStringAsFixed(1), style: const TextStyle(color: AppColors.white)),
                const SizedBox(width: 12),
                const Icon(CupertinoIcons.location, color: AppColors.grey2, size: 14),
                const SizedBox(width: 4),
                Text('${store.distance} km', style: const TextStyle(color: AppColors.grey2, fontSize: 13)),
              ]),
            ]),
          ),
          CupertinoButton(padding: EdgeInsets.zero, child: const Text('View', style: TextStyle(color: AppColors.shop)), onPressed: () {}),
        ]),
      ),
    );
  }
}
