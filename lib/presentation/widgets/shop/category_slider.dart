import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CategorySlider extends StatefulWidget {
  final List<String> categories;
  final Function(String) onCategorySelected;
  const CategorySlider({super.key, required this.categories, required this.onCategorySelected});
  @override
  State<CategorySlider> createState() => _CategorySliderState();
}

class _CategorySliderState extends State<CategorySlider> {
  String? _selected;

  final List<Map<String, String>> _defaults = [
    {'label': 'All', 'emoji': '🔥'},
    {'label': 'Fashion', 'emoji': '👕'},
    {'label': 'Tech', 'emoji': '📱'},
    {'label': 'Home', 'emoji': '🏠'},
    {'label': 'Beauty', 'emoji': '💄'},
    {'label': 'Gaming', 'emoji': '🎮'},
    {'label': 'Audio', 'emoji': '🎧'},
    {'label': 'Sports', 'emoji': '⚽'},
  ];

  @override
  Widget build(BuildContext context) {
    final items = widget.categories.isNotEmpty
        ? widget.categories.map((c) => {'label': c, 'emoji': ''}).toList()
        : _defaults;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final item = items[i];
          final label = item['label']!;
          final emoji = item['emoji']!;
          final isSelected = _selected == null ? i == 0 : _selected == label;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i == 0 ? null : label);
              if (i != 0) widget.onCategorySelected(label);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
              ),
              child: Text('$emoji $label'.trim(),
                style: AppTypography.labelSmall.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                )),
            ),
          );
        },
      ),
    );
  }
}
