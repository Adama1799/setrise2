// material_shop/screens/product/widgets/product_images.dart
import 'package:flutter/material.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/product_model.dart';

class ProductImages extends StatefulWidget {
  final Product product;
  const ProductImages({Key? key, required this.product}) : super(key: key);
  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(widget.product.images[selectedImage]),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.product.images.length,
            (index) => _SmallProductImage(
              isSelected: index == selectedImage,
              press: () => setState(() => selectedImage = index),
              image: widget.product.images[index],
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallProductImage extends StatelessWidget {
  final bool isSelected;
  final VoidCallback press;
  final String image;
  const _SmallProductImage({required this.isSelected, required this.press, required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(8),
        height: 48, width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFFF7643).withOpacity(isSelected ? 1 : 0),
          ),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
