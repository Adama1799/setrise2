import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DatingActions extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onLike;
  const DatingActions({super.key, required this.onPass, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
        onTap: onPass,
        child: Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.live, width: 2),
          boxShadow: [BoxShadow(color: AppColors.live.withOpacity(0.2), blurRadius: 12)]),
          child: const Icon(Icons.close, color: AppColors.live, size: 30))),
      const SizedBox(width: 20),
      GestureDetector(
        onTap: () {},
        child: Container(width: 48, height: 48, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: Colors.amber, width: 1.5)),
          child: const Icon(Icons.star, color: Colors.amber, size: 22))),
      const SizedBox(width: 20),
      GestureDetector(
        onTap: onLike,
        child: Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, border: Border.all(color: AppColors.dateColor, width: 2),
          boxShadow: [BoxShadow(color: AppColors.dateColor.withOpacity(0.2), blurRadius: 12)]),
          child: const Icon(Icons.favorite, color: AppColors.dateColor, size: 30))),
    ]);
  }
}
