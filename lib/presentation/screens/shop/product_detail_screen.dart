import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../providers/shop_provider.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});
  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _qty = 1;
  bool _inCart = false;

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopProvider);
    final product = shopState.products.where((p) => p.id == widget.productId).isNotEmpty
        ? shopState.products.firstWhere((p) => p.id == widget.productId)
        : shopState.products.isNotEmpty ? shopState.products.first : null;

    if (product == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 320, pinned: true, backgroundColor: AppColors.background,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
          actions: [
            IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: product.images.isNotEmpty
                ? CachedNetworkImage(imageUrl: product.images[0], fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.border))
                : Container(color: AppColors.border, child: const Icon(Icons.inventory_2_outlined, size: 80, color: AppColors.textTertiary)),
          ),
        ),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (product.onSale) Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.live, borderRadius: BorderRadius.circular(6)),
              child: Text('-${product.discount}% OFF', style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Inter'))),
            const SizedBox(height: 8),
            Text(product.name, style: AppTypography.headlineLarge),
            const SizedBox(height: 8),
            Row(children: [
              ...List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < product.rating.floor() ? Colors.amber : AppColors.border)),
              const SizedBox(width: 8),
              Text('${product.rating} (${Formatters.formatNumber(product.reviewsCount)} reviews)', style: AppTypography.caption),
            ]),
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(Formatters.formatPrice(product.price), style: AppTypography.headlineLarge.copyWith(color: AppColors.primary)),
              if (product.onSale) ...[const SizedBox(width: 10),
                Text(Formatters.formatPrice(product.originalPrice), style: AppTypography.bodySmall.copyWith(decoration: TextDecoration.lineThrough))],
            ]),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Qty:', style: TextStyle(fontWeight: FontWeight.w600, fontFamily: 'Inter')),
              const SizedBox(width: 12),
              GestureDetector(onTap: () { if (_qty > 1) setState(() => _qty--); },
                child: Container(width: 32, height: 32, decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.remove, size: 16))),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('$_qty', style: AppTypography.labelLarge)),
              GestureDetector(onTap: () => setState(() => _qty++),
                child: Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add, color: AppColors.white, size: 16))),
            ]),
            const SizedBox(height: 20),
            Text('Description', style: AppTypography.h3),
            const SizedBox(height: 8),
            Text(product.description.isNotEmpty ? product.description : 'High-quality product. ${product.stock} items in stock.',
              style: AppTypography.bodySmall),
            const SizedBox(height: 100),
          ]),
        )),
      ]),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 8, top: 12, left: 16, right: 16),
        decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
        child: Row(children: [
          GestureDetector(
            onTap: () { setState(() => _inCart = !_inCart); ref.read(shopProvider.notifier).toggleFavorite(product.id); },
            child: Container(height: 52, width: 100,
              decoration: BoxDecoration(border: Border.all(color: _inCart ? AppColors.primary : AppColors.border, width: 1.5), borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(_inCart ? '✓ Cart' : 'Add Cart',
                style: TextStyle(color: _inCart ? AppColors.primary : AppColors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Inter'))))),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(
            onTap: () {},
            child: Container(height: 52,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text('Buy Now · ${Formatters.formatPrice(product.price * _qty)}',
                style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')))))),
        ]),
      ),
    );
  }
}
