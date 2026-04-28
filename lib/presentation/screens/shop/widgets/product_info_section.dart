// lib/presentation/screens/shop/widgets/product_info_section.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/product_model.dart';

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
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.brand,
              style: AppTextStyles.body2.copyWith(color: AppColors.secondaryText)),
          const SizedBox(height: 4),
          Text(product.name, style: AppTextStyles.headline2),
          const SizedBox(height: 8),
          _buildPriceSection(),
          const SizedBox(height: 8),
          _buildRatingSection(),
          const SizedBox(height: 16),
          _buildSizeSelector(),
          const SizedBox(height: 16),
          _buildColorSelector(),
          const SizedBox(height: 16),
          _buildQuantitySelector(),
          const SizedBox(height: 16),
          _buildExpandableDescription(),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final product = widget.product;
    return Row(
      children: [
        Text('\$${product.price.toStringAsFixed(2)}', style: AppTextStyles.headline1),
        if (product.oldPrice != null) ...[
          const SizedBox(width: 8),
          Text('\$${product.oldPrice!.toStringAsFixed(2)}',
              style: AppTextStyles.body2.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.secondaryText)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
                color: AppColors.error, borderRadius: BorderRadius.circular(4)),
            child: Text('-${product.discountPercentage.round()}%',
                style: AppTextStyles.caption.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }

  Widget _buildRatingSection() {
    final product = widget.product;
    return Row(
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            index < product.rating.floor()
                ? Icons.star
                : index < product.rating
                    ? Icons.star_half
                    : Icons.star_border,
            color: Colors.amber,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text('${product.rating.toStringAsFixed(1)} (${product.reviewsCount} reviews)',
            style: AppTextStyles.body2),
      ],
    );
  }

  Widget _buildSizeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Size', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['XS', 'S', 'M', 'L', 'XL']
              .map((size) => ChoiceChip(
                    label: Text(size),
                    selected: _selectedSize == size,
                    selectedColor: AppColors.accent,
                    onSelected: (selected) =>
                        setState(() => _selectedSize = selected ? size : null),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color', style: AppTextStyles.body1),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: ['Black', 'White', 'Blue', 'Red', 'Green']
              .map((color) => ChoiceChip(
                    label: Text(color),
                    selected: _selectedColor == color,
                    selectedColor: AppColors.accent,
                    onSelected: (selected) =>
                        setState(() => _selectedColor = selected ? color : null),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity', style: AppTextStyles.body1),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null),
              Text('$_quantity', style: AppTextStyles.body1),
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => _quantity++)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Description', style: AppTextStyles.body1),
            IconButton(
              icon: Icon(_isDescriptionExpanded ? Icons.expand_less : Icons.expand_more,
                  color: AppColors.primaryText),
              onPressed: () =>
                  setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
            ),
          ],
        ),
        if (_isDescriptionExpanded)
          Text(widget.product.description, style: AppTextStyles.body2),
      ],
    );
  }
}
