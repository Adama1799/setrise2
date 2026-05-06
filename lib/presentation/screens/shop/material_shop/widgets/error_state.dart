// material_shop/widgets/error_state.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'ghost_button.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: AppDimensions.md),
            Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.lg),
              GhostButton(label: 'Retry', onPressed: onRetry, width: 120),
            ],
          ],
        ),
      ),
    );
  }
}
