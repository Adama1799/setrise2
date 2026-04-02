// lib/presentation/widgets/common/search_input.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchInput({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search users...',
          hintStyle: AppTypography.caption,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: AppTypography.bodySmall,
      ),
    );
  }
}
