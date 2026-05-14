import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/cart_provider.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/cart_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/widgets/empty_state.dart';
import 'package:setrise/presentation/screens/shop/material_shop/screens/checkout/checkout_screen.dart';

void _push(BuildContext ctx, Widget w) => Navigator.push(ctx,
    MaterialPageRoute(builder: (_) => ProviderScope(parent: ProviderScope.containerOf(ctx), child: w)));

const _coupons = {'SAVE10': 10.0, 'WELCOME20': 20.0, 'SETRIZE15': 15.0};

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponCtrl = TextEditingController();
  double _discountPct = 0;
  String? _couponMsg;
  bool _couponValid = false;

  @override
  void dispose() { _couponCtrl.dispose(); super.dispose(); }

  void _applyCoupon() {
    HapticFeedback.lightImpact();
    final code = _couponCtrl.text.trim().toUpperCase();
    if (_coupons.containsKey(code)) {
      setState(() { _discountPct = _coupons[code]!; _couponValid = true; _couponMsg = '🎉 ${_discountPct.toInt()}% discount applied!'; });
    } else {
      setState(() { _discountPct = 0; _couponValid = false; _couponMsg = 'Invalid coupon code'; });
    }
  }

  void _removeCoupon() {
    setState(() { _discountPct = 0; _couponValid = false; _couponMsg = null; _couponCtrl.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final discountAmt = cart.subtotal * (_discountPct / 100);
    final finalTotal = cart.total - discountAmt;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary)),
        title: Text('My Cart', style: AppTextStyles.headline3),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => showDialog(context: context, builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusLg)),
                title: Text('Clear Cart', style: AppTextStyles.headline3),
                content: Text('Remove all items?', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary))),
                  TextButton(onPressed: () { ref.read(cartProvider.notifier).clearCart(); Navigator.pop(context); }, child: Text('Clear', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error, fontWeight: FontWeight.w700))),
                ],
              )),
              child: Text('Clear', style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? const EmptyState(icon: Icons.shopping_bag_outlined, title: 'Your cart is empty', subtitle: 'Discover amazing products and add them to your cart')
          : Column(children: [
              Expanded(
                child: ListView(padding: const EdgeInsets.all(AppDimensions.lg), children: [

                  // Cart items — swipe to delete
                  ...cart.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: Dismissible(
                      key: Key(item.product.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        HapticFeedback.mediumImpact();
                        ref.read(cartProvider.notifier).removeItem(item.product.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('${item.product.name} removed', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                          backgroundColor: AppColors.textSecondary, behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(AppDimensions.lg),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(label: 'Undo', textColor: Colors.white,
                              onPressed: () => ref.read(cartProvider.notifier).addItem(item.product, {}, item.quantity)),
                        ));
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppDimensions.lg),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
                          SizedBox(height: 4),
                          Text('Delete', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
                        ]),
                      ),
                      child: _CartItemCard(item: item),
                    ),
                  )),

                  const SizedBox(height: AppDimensions.sm),

                  // Coupon Code
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Coupon Code', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: AppDimensions.sm),
                      Row(children: [
                        Expanded(child: TextField(
                          controller: _couponCtrl,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Enter code (e.g. SAVE10)',
                            hintStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.textQuaternary, letterSpacing: 0, fontWeight: FontWeight.w400),
                            filled: true, fillColor: AppColors.backgroundPrimary, contentPadding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: 12),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm), borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm), borderSide: const BorderSide(color: AppColors.ctaPrimaryBg, width: 1.5)),
                            suffixIcon: _couponValid ? IconButton(icon: const Icon(Icons.close, size: 16, color: AppColors.textTertiary), onPressed: _removeCoupon) : null,
                          ),
                        )),
                        const SizedBox(width: AppDimensions.sm),
                        SizedBox(height: 44, child: ElevatedButton(
                          onPressed: _applyCoupon,
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusSm))),
                          child: Text('Apply', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        )),
                      ]),
                      if (_couponMsg != null) ...[
                        const SizedBox(height: AppDimensions.xs),
                        Text(_couponMsg!, style: AppTextStyles.caption.copyWith(color: _couponValid ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
                      ],
                      const SizedBox(height: AppDimensions.xs),
                      Text('Available: SAVE10 · WELCOME20 · SETRIZE15', style: AppTextStyles.caption.copyWith(color: AppColors.textQuaternary)),
                    ]),
                  ),

                  const SizedBox(height: AppDimensions.sm),

                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))]),
                    child: Column(children: [
                      _SumRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: AppDimensions.xs),
                      _SumRow('Shipping', cart.shipping == 0 ? 'FREE' : '\$${cart.shipping.toStringAsFixed(2)}', valueColor: cart.shipping == 0 ? AppColors.success : null),
                      const SizedBox(height: AppDimensions.xs),
                      _SumRow('Tax (8%)', '\$${cart.tax.toStringAsFixed(2)}'),
                      if (_discountPct > 0) ...[
                        const SizedBox(height: AppDimensions.xs),
                        _SumRow('Coupon (-${_discountPct.toInt()}%)', '-\$${discountAmt.toStringAsFixed(2)}', valueColor: AppColors.success),
                      ],
                      const Padding(padding: EdgeInsets.symmetric(vertical: AppDimensions.sm), child: Divider(color: AppColors.borderSubtle, height: 1)),
                      _SumRow('Total', '\$${finalTotal.toStringAsFixed(2)}', isBold: true),
                    ]),
                  ),
                  const SizedBox(height: AppDimensions.lg),
                ]),
              ),

              // Checkout Button
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, -4))]),
                padding: EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm, AppDimensions.lg, MediaQuery.of(context).padding.bottom + AppDimensions.sm),
                child: SizedBox(width: double.infinity, height: 52, child: ElevatedButton.icon(
                  onPressed: () => _push(context, const CheckoutScreen()),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.ctaPrimaryBg, foregroundColor: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd))),
                  icon: const Icon(Icons.payment_outlined, size: 20),
                  label: Text('Checkout  ·  \$${finalTotal.toStringAsFixed(2)}', style: AppTextStyles.buttonLabel),
                )),
              ),
            ]),
    );
  }
}

class _CartItemCard extends ConsumerWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppDimensions.radiusMd), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 2))]),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          child: SizedBox(width: 80, height: 80, child: CachedNetworkImage(
            imageUrl: item.product.images.isNotEmpty ? item.product.images.first : '',
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => const ColoredBox(color: AppColors.backgroundPrimary, child: Icon(Icons.image_outlined, color: AppColors.textQuaternary)),
          ))),
        const SizedBox(width: AppDimensions.md),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.product.brand.toUpperCase(), style: AppTextStyles.caption.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w700, fontSize: 10)),
          const SizedBox(height: 2),
          Text(item.product.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: AppDimensions.xs),
          Text('\$${item.product.price.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(color: AppColors.ctaPrimaryBg, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppDimensions.xs),
          Row(children: [
            _QBtn(icon: Icons.remove, onTap: () => notifier.updateQuantity(item.product.id, item.quantity - 1)),
            Container(width: 36, alignment: Alignment.center, child: Text('${item.quantity}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800))),
            _QBtn(icon: Icons.add, onTap: () => notifier.updateQuantity(item.product.id, item.quantity + 1)),
            const Spacer(),
            Text('\$${item.subtotal.toStringAsFixed(2)}', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          ]),
        ])),
      ]),
    );
  }
}

class _QBtn extends StatelessWidget {
  final IconData icon; final VoidCallback onTap;
  const _QBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap, child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.backgroundPrimary, borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 14, color: AppColors.textPrimary)));
}

class _SumRow extends StatelessWidget {
  final String label, value; final bool isBold; final Color? valueColor;
  const _SumRow(this.label, this.value, {this.isBold = false, this.valueColor});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: isBold ? AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary) : AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
    Text(value, style: isBold ? AppTextStyles.priceMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary) : AppTextStyles.bodySmall.copyWith(color: valueColor ?? AppColors.textPrimary, fontWeight: FontWeight.w600)),
  ]);
}
