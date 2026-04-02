// lib/presentation/widgets/shop/category_slider.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CategorySlider extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;

  const CategorySlider({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return GestureDetector(
              onTap: () {
                setState(() => _selectedIndex = 0);
                widget.onCategorySelected('');
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0
                      ? AppColors.primary
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'All',
                    style: AppTypography.labelMedium.copyWith(
                      color: _selectedIndex == 0
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }

          final category = widget.categories[index - 1];
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onCategorySelected(category);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  category,
                  style: AppTypography.labelMedium.copyWith(
                    color: _selectedIndex == index
                        ? AppColors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
