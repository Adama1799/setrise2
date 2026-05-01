hereimport 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cats = ['Electronics', 'Fashion', 'Home', 'Beauty', 'Sports'];
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: cats.length,
        itemBuilder: (_, i) => Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(child: Text(cats[i], style: const TextStyle(color: AppColors.white))),
        ),
      ),
    );
  }
}
