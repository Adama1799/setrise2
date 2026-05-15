import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/cart/cart_screen.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/search/search_Screen.dart';

void _push(BuildContext ctx, Widget w) => Navigator.push(ctx,
    MaterialPageRoute(builder: (_) => ProviderScope(parent: ProviderScope.containerOf(ctx), child: w)));

class HomeHeader extends ConsumerWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider).itemCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, 0),
      child: Row(children: [
        // Logo + title
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Welcome back 👋',
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
          Text('SetRize Shop',
              style: AppTextStyles.headline2.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w800)),
        ]),
        const Spacer(),

        // Search button
        GestureDetector(
          onTap: () => _push(context, const SearchScreen()),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              border: const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle)),
            ),
            child: const Icon(Icons.search, size: 20, color: AppColors.textPrimary),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),

        // Cart button with badge
        GestureDetector(
          onTap: () => _push(context, const CartScreen()),
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: const Border.fromBorderSide(BorderSide(color: AppColors.borderSubtle)),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.textPrimary),
            ),
            if (cartCount > 0)
              Positioned(
                top: -4, right: -4,
                child: Container(
                  width: 18, height: 18,
                  decoration: const BoxDecoration(color: AppColors.badgeCartBg, shape: BoxShape.circle),
                  child: Center(child: Text('$cartCount',
                      style: const TextStyle(fontSize: 10, color: AppColors.badgeCartFg, fontWeight: FontWeight.w800, fontFamily: 'Inter'))),
                ),
              ),
          ]),
        ),
      ]),
    );
  }
}
