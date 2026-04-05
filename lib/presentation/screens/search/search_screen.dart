import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Search', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
      ),
      body: Center(
        child: Text(
          'Search Screen - Coming Soon',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
