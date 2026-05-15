import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';

const _kCategories = [
  {'icon': '🔥', 'label': 'Hot'},
  {'icon': '📱', 'label': 'Tech'},
  {'icon': '👗', 'label': 'Fashion'},
  {'icon': '🎮', 'label': 'Gaming'},
  {'icon': '🏠', 'label': 'Home'},
  {'icon': '💄', 'label': 'Beauty'},
  {'icon': '📚', 'label': 'Books'},
  {'icon': '🏋️', 'label': 'Sports'},
];

class Categories extends StatefulWidget {
  final ValueChanged<int>? onSelected;
  const Categories({Key? key, this.onSelected}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        itemCount: _kCategories.length,
        itemBuilder: (context, i) {
          final cat = _kCategories[i];
          final isSelected = _selected == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onSelected?.call(i);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: AppDimensions.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.ctaPrimaryBg : AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                      border: isSelected
                          ? null
                          : const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle)),
                      boxShadow: isSelected
                          ? [BoxShadow(color: AppColors.ctaPrimaryBg.withOpacity(0.3), blurRadius: 8, spreadRadius: 1)]
                          : null,
                    ),
                    child: Center(
                      child: Text(cat['icon']!, style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat['label']!,
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? AppColors.ctaPrimaryBg : AppColors.textTertiary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
