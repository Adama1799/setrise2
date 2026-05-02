// lib/presentation/screens/shop/product/widgets/hero_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class HeroSection extends StatefulWidget {
  final List<String> images;
  final String heroTag;
  const HeroSection({super.key, required this.images, required this.heroTag});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  late PageController _pc = PageController();
  int _cur = 0;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.heroTag,
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pc,
              onPageChanged: (i) => setState(() => _cur = i),
              itemCount: widget.images.length,
              itemBuilder: (_, i) => Image.network(widget.images[i], fit: BoxFit.contain),
            ),
            if (widget.images.length > 1)
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _cur == i ? AppColors.accent : AppColors.border,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
