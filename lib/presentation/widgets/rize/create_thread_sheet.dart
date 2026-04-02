// lib/presentation/widgets/rize/create_thread_sheet.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CreateThreadSheet extends StatefulWidget {
  final Function(String content, String? mediaUrl) onPost;

  const CreateThreadSheet({
    super.key,
    required this.onPost,
  });

  @override
  State<CreateThreadSheet> createState() => _CreateThreadSheetState();
}

class _CreateThreadSheetState extends State<CreateThreadSheet> {
  final _controller = TextEditingController();
  String? _selectedMediaUrl;

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
                    const Text('New Thread', style: AppTypography.h3),
                    GestureDetector(
                      onTap: _controller.text.isEmpty
                          ? null
                          : () {
                              widget.onPost(_controller.text, _selectedMediaUrl);
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
                // Media Preview (1000x650px aspect ratio)
                if (_selectedMediaUrl != null)
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.surface,
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            _selectedMediaUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedMediaUrl = null),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.black.withOpacity(0.7),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                // Bottom Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: AppColors.primary),
                      onPressed: () {
                        // Pick image
                        setState(() {
                          _selectedMediaUrl =
                              'https://via.placeholder.com/1000x650?text=Thread+Image';
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.videocam, color: AppColors.primary),
                      onPressed: () {
                        // Pick video
                        setState(() {
                          _selectedMediaUrl =
                              'https://via.placeholder.com/1000x650?text=Thread+Video';
                        });
                      },
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
