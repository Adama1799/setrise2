// lib/presentation/screens/shop/widgets/product_grid_card.dart
import 'package:flutter/cupertino.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/product_model.dart';
import '../product/product_detail_screen.dart';

class ProductGridCard extends StatefulWidget {
  final ProductModel product;
  const ProductGridCard({super.key, required this.product});

  @override
  State<ProductGridCard> createState() => _ProductGridCardState();
}

class _ProductGridCardState extends State<ProductGridCard> {
  late bool _isFav;

  @override
  void initState() {
    super.initState();
    _isFav = widget.product.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p.oldPrice != null;
    return GestureDetector(
      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => ProductDetailScreen(product: p))),
      child: Container(
        decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(flex: 6, child: Stack(children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), child: Image.network(p.images.first, width: double.infinity, fit: BoxFit.cover)),
            if (hasDiscount) Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.neonRed, borderRadius: BorderRadius.circular(4)), child: Text('-${p.discountPercentage.round()}%', style: const TextStyle(color: AppColors.white, fontSize: 11)))),
            Positioned(top: 8, right: 8, child: GestureDetector(onTap: () => setState(() => _isFav = !_isFav), child: Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.black.withOpacity(0.4), shape: BoxShape.circle), child: Icon(_isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart, color: _isFav ? AppColors.neonRed : AppColors.white, size: 16)))),
          ])),
          Expanded(flex: 4, child: Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            const Spacer(),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.shop, fontWeight: FontWeight.bold)),
                if (hasDiscount) Text('\$${p.oldPrice!.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.grey2, decoration: TextDecoration.lineThrough, fontSize: 11)),
              ]),
              CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.cart_fill_badge_plus, color: AppColors.shop, size: 20), onPressed: () {}),
            ]),
          ]))),
        ]),
      ),
    );
  }
}
