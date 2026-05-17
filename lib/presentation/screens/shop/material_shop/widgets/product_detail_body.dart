// lib/presentation/screens/shop/material_shop/widgets/product_detail_body.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/review_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_widgets.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_selectors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_detail_tabs.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/product_palette_utils.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/review/write_review_screen.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/comments/comments_screen.dart';

class ProductDetailBody extends ConsumerWidget {
  final ProductModel p;
  final Color elegant, accent;
  final List<ReviewModel> reviews;
  final double avg;
  final TabController tabCtrl;
  final String? selectedSize;
  final Color? selectedColor;
  final List<String> sizes;
  final List<Color> colors;
  final int qty;
  final Map<String, String> seller;
  final ValueChanged<String> onSizeSelected;
  final ValueChanged<Color> onColorSelected;
  final VoidCallback onQtyDecrement, onQtyIncrement, onChatTap;

  const ProductDetailBody({
    Key? key,
    required this.p,
    required this.elegant,
    required this.accent,
    required this.reviews,
    required this.avg,
    required this.tabCtrl,
    required this.selectedSize,
    required this.selectedColor,
    required this.sizes,
    required this.colors,
    required this.qty,
    required this.seller,
    required this.onSizeSelected,
    required this.onColorSelected,
    required this.onQtyDecrement,
    required this.onQtyIncrement,
    required this.onChatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewCount = reviews.isEmpty ? p.reviewCount : reviews.length;
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Product info ──────────────────────────────────
          DetailSection(
            elegant: elegant,
            child: ProductInfoHeader(
              p: p, accent: accent, elegant: elegant,
              avg: avg, reviewCount: reviewCount, tabCtrl: tabCtrl,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── Color picker ──────────────────────────────────
          DetailSection(
            elegant: elegant,
            child: ColorPicker(
              accent: accent, colors: colors,
              selectedColor: selectedColor, onColorSelected: onColorSelected,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── Size picker ───────────────────────────────────
          DetailSection(
            elegant: elegant,
            child: SizePicker(
              accent: accent, sizes: sizes,
              selectedSize: selectedSize, onSizeSelected: onSizeSelected,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── Seller ────────────────────────────────────────
          DetailSection(
            elegant: elegant,
            child: SellerCard(
              seller: seller, elegant: elegant,
              accent: accent, onChatTap: onChatTap,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── Quantity ──────────────────────────────────────
          DetailSection(
            elegant: elegant,
            child: QuantityRow(
              p: p, accent: accent, qty: qty,
              onDecrement: onQtyDecrement, onIncrement: onQtyIncrement,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── ✅ Social Bar (جديد) ───────────────────────────
          ProductSocialBar(
            productId: p.id,
            productName: p.name,
            accent: accent,
            elegant: elegant,
          ),
          const SizedBox(height: AppDimensions.sm),

          // ── Tab bar ───────────────────────────────────────
          Container(
            color: Colors.white.withOpacity(0.85),
            child: TabBar(
              controller: tabCtrl,
              indicatorColor: accent,
              indicatorWeight: 2.5,
              labelColor: accent,
              unselectedLabelColor: AppColors.textTertiary,
              labelStyle: AppTextStyles.bodySmall
                  .copyWith(fontWeight: FontWeight.w700),
              unselectedLabelStyle: AppTextStyles.bodySmall,
              tabs: [
                const Tab(text: 'Description'),
                Tab(text: 'Reviews ($reviewCount)'),
              ],
            ),
          ),

          // ── Tab views ─────────────────────────────────────
          SizedBox(
            height: 380,
            child: TabBarView(
              controller: tabCtrl,
              children: [
                DescriptionTab(p: p, accent: accent),
                ReviewsTab(
                  p: p, reviews: reviews, avg: avg, accent: accent,
                  onWriteReview: () => pushScreen(
                    context,
                    WriteReviewScreen(productId: p.id, productName: p.name),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// ✅ ProductSocialBar — شريط التفاعل الاجتماعي
// ═══════════════════════════════════════════════════════════════
class ProductSocialBar extends StatefulWidget {
  final String productId;
  final String productName;
  final Color accent;
  final Color elegant;

  const ProductSocialBar({
    Key? key,
    required this.productId,
    required this.productName,
    required this.accent,
    required this.elegant,
  }) : super(key: key);

  @override
  State<ProductSocialBar> createState() => _ProductSocialBarState();
}

class _ProductSocialBarState extends State<ProductSocialBar> {
  bool _liked = false;
  bool _saved = false;
  bool _recommended = false;
  int _likeCount = 128;
  int _recommendCount = 47;
  int _commentCount = 23;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: widget.elegant.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: widget.elegant.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // ❤️ إعجاب
          _SocialBtn(
            icon: _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            label: _formatCount(_likeCount),
            color: _liked ? Colors.red : AppColors.textTertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _liked = !_liked;
                _likeCount += _liked ? 1 : -1;
              });
            },
          ),

          _Divider(),

          // 🔺 ترشيح
          _SocialBtn(
            icon: _recommended
                ? Icons.recommend_rounded
                : Icons.recommend_outlined,
            label: _formatCount(_recommendCount),
            color: _recommended ? widget.accent : AppColors.textTertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() {
                _recommended = !_recommended;
                _recommendCount += _recommended ? 1 : -1;
              });
            },
          ),

          _Divider(),

          // 💬 تعليقات — تفتح CommentsScreen
          _SocialBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: _formatCount(_commentCount),
            color: AppColors.textTertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              pushScreen(
                context,
                CommentsScreen(
                  productId: widget.productId,
                  productName: widget.productName,
                  accent: widget.accent,
                ),
              );
            },
          ),

          _Divider(),

          // 🔖 حفظ
          _SocialBtn(
            icon: _saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
            label: 'Save',
            color: _saved ? widget.accent : AppColors.textTertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              setState(() => _saved = !_saved);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _saved ? 'Saved!' : 'Removed from saved',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: widget.accent,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  margin: const EdgeInsets.all(AppDimensions.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              );
            },
          ),

          _Divider(),

          // 📤 مشاركة
          _SocialBtn(
            icon: Icons.ios_share_rounded,
            label: 'Share',
            color: AppColors.textTertiary,
            onTap: () {
              HapticFeedback.lightImpact();
              // يمكن ربطه بـ share_plus لاحقاً
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sharing ${widget.productName}...',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.textSecondary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  margin: const EdgeInsets.all(AppDimensions.lg),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return '$count';
  }
}

// ─────────────────────────────────────────────────────────────
// زر اجتماعي واحد (أيقونة + نص)
// ─────────────────────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 3),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// فاصل عمودي خفيف
// ─────────────────────────────────────────────────────────────
class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.borderSubtle,
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Product Info Header
// ═══════════════════════════════════════════════════════════════
class ProductInfoHeader extends StatelessWidget {
  final ProductModel p;
  final Color accent, elegant;
  final double avg;
  final int reviewCount;
  final TabController tabCtrl;

  const ProductInfoHeader({
    Key? key,
    required this.p,
    required this.accent,
    required this.elegant,
    required this.avg,
    required this.reviewCount,
    required this.tabCtrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.15),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: Text(
                p.brand.toUpperCase(),
                style: AppTextStyles.caption.copyWith(
                    color: accent, fontWeight: FontWeight.w700),
              ),
            ),
            const Spacer(),
            if (p.isHot) SmallBadge('🔥 HOT', AppColors.badgeHotBg),
            if (p.isNew)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: SmallBadge('✨ NEW', AppColors.badgeNewBg),
              ),
            if (p.discount > 0)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child:
                    SmallBadge('-${p.discount}%', AppColors.badgeSaleBg),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        Text(
          p.name,
          style: AppTextStyles.headline3.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppDimensions.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${p.price.toStringAsFixed(2)}',
              style: AppTextStyles.priceLarge.copyWith(
                  color: accent, fontWeight: FontWeight.w800),
            ),
            if (p.originalPrice > 0) ...[
              const SizedBox(width: AppDimensions.sm),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  '\$${p.originalPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.priceStrike,
                ),
              ),
            ],
            const Spacer(),
            GestureDetector(
              onTap: () => tabCtrl.animateTo(1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: elegant.withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: AppColors.ratingFilled),
                    const SizedBox(width: 3),
                    Text(
                      avg.toStringAsFixed(1),
                      style: AppTextStyles.bodySmall
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      ' ($reviewCount)',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (p.shippingFree)
          Padding(
            padding: const EdgeInsets.only(top: AppDimensions.sm),
            child: Row(
              children: [
                Icon(Icons.local_shipping_rounded,
                    size: 14, color: accent),
                const SizedBox(width: 4),
                Text(
                  'Free Shipping',
                  style: AppTextStyles.caption.copyWith(
                      color: accent, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
