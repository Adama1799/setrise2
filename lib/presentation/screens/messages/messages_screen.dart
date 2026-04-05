import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Messages', style: AppTextStyles.h4.copyWith(color: AppColors.white)),
      ),
      body: Center(
        child: Text(
          'Messages Screen - Coming Soon',
          style: AppTextStyles.h5.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
