import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_text_styles.dart';
import '../utils/platform_utils.dart';

class SearchBarWidget extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({
    super.key,
    this.readOnly = true,
    this.onTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'homeSearchBar',
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onTap ?? () => context.push('/search'),
          child: Container(
            height: AppDimensions.minTapTarget,
            decoration: BoxDecoration(
              color: AppColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
            child: Row(
              children: [
                const Icon(Icons.search, size: 20, color: AppColors.textTertiary),
                const SizedBox(width: AppDimensions.xs),
                Expanded(
                  child: readOnly
                      ? Text('Search products...', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textQuaternary))
                      : TextField(
                          controller: controller,
                          onChanged: onChanged,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: 'Search products...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textQuaternary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                ),
                if (PlatformUtils.isMobile && readOnly)
                  const Icon(Icons.mic_none, size: 20, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
