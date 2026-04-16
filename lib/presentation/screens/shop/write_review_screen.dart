// lib/presentation/screens/shop/write_review_screen.dart

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class WriteReviewScreen extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;

  const WriteReviewScreen({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  int _rating = 5;
  final List<String> _selectedPhotos = [];

  @override
  void dispose() {
    _reviewController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_titleController.text.trim().isEmpty || _reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), backgroundColor: AppColors.neonRed),
      );
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your review! 🎉'), backgroundColor: AppColors.neonGreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Write a Review',
          style: AppTextStyles.h5.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _submitReview,
            child: Text(
              'Submit',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.shop, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.productImage,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80, height: 80,
                      color: AppColors.grey,
                      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.grey2),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.productName,
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Rating
            Text(
              'Overall Rating',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      index < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            // Review title
            Text(
              'Review Title',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Summarize your experience',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            // Review content
            Text(
              'Your Review',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.white),
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Share your experience with this product...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey2),
                filled: true,
                fillColor: AppColors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            // Add photos
            Text(
              'Add Photos (Optional)',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ..._selectedPhotos.map((photo) => Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey.withOpacity(0.3)),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          color: AppColors.grey,
                          child: const Icon(Icons.image_rounded, color: AppColors.grey2, size: 30),
                        ),
                      ),
                      Positioned(
                        top: 4, right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPhotos.remove(photo)),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(color: AppColors.neonRed, shape: BoxShape.circle),
                            child: const Icon(Icons.close_rounded, color: AppColors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
                if (_selectedPhotos.length < 5)
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedPhotos.add('photo_${_selectedPhotos.length + 1}'));
                    },
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey.withOpacity(0.3), style: BorderStyle.solid),
                      ),
                      child: const Icon(Icons.add_photo_alternate_rounded, color: AppColors.grey2, size: 30),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
