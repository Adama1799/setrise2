// lib/presentation/widgets/post/create_post_bottom_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CreatePostBottomSheet extends StatefulWidget {
  final Function(String content, List<String> mediaUrls) onPost;

  const CreatePostBottomSheet({
    super.key,
    required this.onPost,
  });

  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final _controller = TextEditingController();
  List<String> _mediaUrls = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: AppTypography.labelMedium,
                      ),
                    ),
                    const Text(
                      'Create Post',
                      style: AppTypography.h3,
                    ),
                    GestureDetector(
                      onTap: _controller.text.isEmpty
                          ? null
                          : () {
                              widget.onPost(_controller.text, _mediaUrls);
                              Navigator.pop(context);
                            },
                      child: Text(
                        'Post',
                        style: AppTypography.labelLarge.copyWith(
                          color: _controller.text.isEmpty
                              ? AppColors.textTertiary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: AppColors.border),
                const SizedBox(height: 20),
                // Text Input
                TextField(
                  controller: _controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "What's on your mind?",
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: InputBorder.none,
                  ),
                  style: AppTypography.bodyLarge,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                // Bottom Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: AppColors.primary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on, color: AppColors.primary),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.emoji_emotions, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
