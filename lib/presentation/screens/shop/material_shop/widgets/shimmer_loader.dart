// material_shop/widgets/shimmer_loader.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  const ShimmerLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSkeleton,
      highlightColor: AppColors.backgroundSkeletonShine,
      direction: ShimmerDirection.ltr,
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}
