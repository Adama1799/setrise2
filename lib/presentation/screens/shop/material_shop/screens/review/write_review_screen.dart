import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_colors.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_text_styles.dart';
import 'package:setrise/presentation/screens/shop/material_shop/theme/app_dimensions.dart';
import 'package:setrise/presentation/screens/shop/material_shop/models/review_model.dart';
import 'package:setrise/presentation/screens/shop/material_shop/providers/reviews_provider.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String productId;
  final String productName;

  const WriteReviewScreen({
    Key? key,
    required this.productId,
    this.productName = '',
  }) : super(key: key);

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _rating = 0;
  final _ctrl = TextEditingController();
  bool _submitting = false;

  static const _labels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];
  static const _labelColors = [
    Colors.transparent,
    Color(0xFFFF3B30),
    Color(0xFFFF9500),
    Color(0xFFFFCC00),
    Color(0xFF34C759),
    Color(0xFF007AFF),
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a rating', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
        backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      ));
      return;
    }
    if (_ctrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Review must be at least 10 characters', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
        backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppDimensions.lg),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
      ));
      return;
    }

    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    ref.read(reviewsProvider.notifier).addReview(ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      productId: widget.productId,
      userName: 'You',
      rating: _rating.toDouble(),
      comment: _ctrl.text.trim(),
      date: DateTime.now(),
    ));

    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Review submitted! Thank you 🎉', style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppDimensions.lg),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.white, surfaceTintColor: Colors.white, elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.textPrimary),
        ),
        title: Text('Write Review', style: AppTextStyles.headline3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // Product name card
          if (widget.productName.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
              ),
              child: Row(children: [
                const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.ctaPrimaryBg),
                const SizedBox(width: AppDimensions.sm),
                Expanded(child: Text(widget.productName,
                    style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]),
            ),

          const SizedBox(height: AppDimensions.xl),

          // Star Rating
          Center(child: Column(children: [
            Text('Your Rating', style: AppTextStyles.headline3),
            const SizedBox(height: AppDimensions.md),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () { HapticFeedback.lightImpact(); setState(() => _rating = star); },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    _rating >= star ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 48,
                    color: _rating >= star ? AppColors.ratingFilled : AppColors.borderMedium,
                  ),
                ),
              );
            })),
            if (_rating > 0) ...[
              const SizedBox(height: AppDimensions.sm),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(_labels[_rating], key: ValueKey(_rating),
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: _labelColors[_rating], fontWeight: FontWeight.w700)),
              ),
            ],
          ])),

          const SizedBox(height: AppDimensions.xl),

          // Review Text
          Text('Your Review', style: AppTextStyles.headline3),
          const SizedBox(height: AppDimensions.sm),
          TextField(
            controller: _ctrl,
            maxLines: 5, maxLength: 500,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Share your experience with this product...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textQuaternary),
              filled: true, fillColor: Colors.white,
              counterStyle: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: const BorderSide(color: AppColors.borderSubtle)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: const BorderSide(color: AppColors.borderSubtle)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd), borderSide: const BorderSide(color: AppColors.ctaPrimaryBg, width: 1.5)),
            ),
          ),

          const SizedBox(height: AppDimensions.xl),

          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ctaPrimaryBg,
                disabledBackgroundColor: AppColors.ctaPrimaryDisabledBg,
                foregroundColor: Colors.white, elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusMd)),
              ),
              child: _submitting
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text('Submit Review', style: AppTextStyles.buttonLabel),
            ),
          ),
        ]),
      ),
    );
  }
}
