// lib/presentation/widgets/dating/dating_actions.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class DatingActions extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onLike;

  const DatingActions({
    super.key,
    required this.onPass,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Pass Button
          GestureDetector(
            onTap: onPass,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.textTertiary,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.textTertiary,
                size: 28,
              ),
            ),
          ),
          // Like Button
          GestureDetector(
            onTap: onLike,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.dateColor,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dateColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.favorite,
                color: AppColors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
