// material_shop/widgets/empty_state.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? ctaLabel;
  final VoidCallback? onCta;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.ctaLabel,
    this.onCta,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: AppColors.textQuaternary),
            const SizedBox(height: AppDimensions.md),
            Text(title, style: AppTextStyles.headline3, textAlign: TextAlign.center),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(subtitle!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary), textAlign: TextAlign.center),
            ],
            if (ctaLabel != null) ...[
              const SizedBox(height: AppDimensions.xl),
              PrimaryButton(label: ctaLabel!, onPressed: onCta, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}
