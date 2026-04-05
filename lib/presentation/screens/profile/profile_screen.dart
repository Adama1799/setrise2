import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Profile', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
      ),
      body: Center(
        child: Text(
          'Profile Screen - Coming Soon',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
