// lib/presentation/screens/shop/product/widgets/product_info_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../data/models/product_model.dart';

class ProductInfoSection extends StatefulWidget {
  final ProductModel product;
  const ProductInfoSection({super.key, required this.product});

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  int _quantity = 1;
  String? _selectedSize;
  String? _selectedColor;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(p.brand, style: const TextStyle(color: AppColors.grey2)),
        const SizedBox(height: 4),
        Text(p.name, style: const TextStyle(color: AppColors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(children: [
          Text('\$${p.price.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.shop, fontSize: 22, fontWeight: FontWeight.bold)),
          if (p.oldPrice != null) ...[
            const SizedBox(width: 8),
            Text('\$${p.oldPrice!.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.grey2, decoration: TextDecoration.lineThrough)),
          ]
        ]),
        const SizedBox(height: 8),
        Row(children: List.generate(5, (i) => Icon(i < p.rating.floor() ? CupertinoIcons.star_fill : CupertinoIcons.star, color: CupertinoColors.systemYellow, size: 16))),
        const SizedBox(height: 16),
        const Text('Size', style: TextStyle(color: AppColors.white)),
        Wrap(spacing: 8, children: ['XS','S','M','L','XL'].map((s) => ChoiceChip(label: Text(s), selected: _selectedSize == s, selectedColor: AppColors.accent, onSelected: (b) => setState(() => _selectedSize = b ? s : null)))),
        const SizedBox(height: 16),
        const Text('Color', style: TextStyle(color: AppColors.white)),
        Wrap(spacing: 8, children: ['Black','White','Blue'].map((c) => ChoiceChip(label: Text(c), selected: _selectedColor == c, selectedColor: AppColors.accent, onSelected: (b) => setState(() => _selectedColor = b ? c : null)))),
        const SizedBox(height: 16),
        Row(children: [
          const Text('Qty', style: TextStyle(color: AppColors.white)),
          const Spacer(),
          CupertinoButton(child: const Icon(CupertinoIcons.minus), onPressed: () => setState(() { if (_quantity > 1) _quantity--; })),
          Text('$_quantity', style: const TextStyle(color: AppColors.white)),
          CupertinoButton(child: const Icon(CupertinoIcons.add), onPressed: () => setState(() => _quantity++)),
        ]),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Row(children: [
            const Text('Description', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(_expanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down, color: AppColors.grey2),
          ]),
        ),
        if (_expanded) ...[const SizedBox(height: 8), Text(p.description, style: const TextStyle(color: AppColors.grey2))],
      ]),
    );
  }
}

class ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final ValueChanged<bool> onSelected;
  const ChoiceChip({required this.label, required this.selected, required this.selectedColor, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(!selected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? selectedColor : AppColors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(color: selected ? AppColors.black : AppColors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
