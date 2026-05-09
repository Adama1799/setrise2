import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/cart_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/checkout/checkout_screen.dart';

void _push(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: screen,
      ),
    ),
  );
}

class CartScreen extends ConsumerWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textPrimary),
        ),
        title: Text('My Cart', style: AppTextStyles.headline3),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clearCart(),
              child: Text('Clear',
                  style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              subtitle: 'Add some products to get started',
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppDimensions.sm),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _CartItemCard(item: item, index: index);
                    },
                  ),
                ),
                _OrderSummary(cart: cart),
              ],
            ),
    );
  }
}

// ─── Cart Item Card ───
class _CartItemCard extends ConsumerWidget {
  final CartItem item;
  final int index;
  const _CartItemCard({required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: const Border.fromBorderSide(
            BorderSide(color: AppColors.borderSubtle, width: 0.5)),
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: SizedBox(
              width: 80, height: 80,
              child: CachedNetworkImage(
                imageUrl: item.product.images.isNotEmpty
                    ? item.product.images.first
                    : '',
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const ColoredBox(
                  color: AppColors.backgroundTertiary,
                  child: Icon(Icons.image_not_supported,
                      color: AppColors.textQuaternary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),

          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.brand.toUpperCase(),
                    style: AppTextStyles.labelUpper.copyWith(
                        color: AppColors.textTertiary, fontSize: 10)),
                const SizedBox(height: 2),
                Text(item.product.name,
                    style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: AppDimensions.xs),
                Text('\$${item.product.price.toStringAsFixed(2)}',
                    style: AppTextStyles.priceSmall.copyWith(
                        color: AppColors.ctaPrimaryBg)),
                const SizedBox(height: AppDimensions.xs),
                // Quantity controls
                Row(
                  children: [
                    _QtyBtn(
                      icon: Icons.remove,
                      onTap: () => notifier.updateQuantity(
                          item.product.id, item.quantity - 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm),
                      child: Text('${item.quantity}',
                          style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w700)),
                    ),
                    _QtyBtn(
                      icon: Icons.add,
                      onTap: () => notifier.updateQuantity(
                          item.product.id, item.quantity + 1),
                    ),
                    const Spacer(),
                    // Subtotal
                    Text('\$${item.subtotal.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: AppDimensions.xs),
          // Delete button
          GestureDetector(
            onTap: () => notifier.removeItem(item.product.id),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.statusCancelledBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(Icons.delete_outline,
                  size: 16, color: AppColors.statusCancelledFg),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Summary ───
class _OrderSummary extends ConsumerWidget {
  final CartState cart;
  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: const BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border(
            top: BorderSide(color: AppColors.borderSubtle, width: 0.5)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: '\$${cart.subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: AppDimensions.xs),
          _SummaryRow(
            label: 'Shipping',
            value: cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}',
            valueColor: cart.shipping == 0 ? AppColors.success : null,
          ),
          const SizedBox(height: AppDimensions.xs),
          _SummaryRow(label: 'Tax (8%)', value: '\$${cart.tax.toStringAsFixed(2)}'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimensions.sm),
            child: Divider(color: AppColors.borderSubtle, height: 1),
          ),
          _SummaryRow(
            label: 'Total',
            value: '\$${cart.total.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: AppDimensions.md),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _push(context, const CheckoutScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ctaPrimaryBg,
                foregroundColor: AppColors.ctaPrimaryFg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd)),
              ),
              icon: const Icon(Icons.payment_outlined, size: 20),
              label: Text('Proceed to Checkout',
                  style: AppTextStyles.buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: isBold
                ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)
                : AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
        Text(value,
            style: isBold
                ? AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800)
                : AppTextStyles.bodySmall.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: AppColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: AppColors.textPrimary),
      ),
    );
  }
}
