// lib/presentation/widgets/rize/reply_thread_sheet.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/thread_model.dart';

class ReplyThreadSheet extends StatefulWidget {
  final ThreadModel thread;

  const ReplyThreadSheet({
    super.key,
    required this.thread,
  });

  @override
  State<ReplyThreadSheet> createState() => _ReplyThreadSheetState();
}

class _ReplyThreadSheetState extends State<ReplyThreadSheet> {
  final _replyController = TextEditingController();
  final List<ThreadModel> _replies = [];

  @override
  void initState() {
    super.initState();
    _replies.addAll(widget.thread.threadReplies);
  }

  @override
  void dispose() {
    _replyController.dispose();
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
        builder: (context, scrollController) => Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text('Cancel', style: AppTypography.labelMedium),
                  ),
                  const Text('Replies', style: AppTypography.h3),
                  const SizedBox(width: 60),
                ],
              ),
            ),
            Divider(color: AppColors.border),
            // Original Thread
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.thread.authorAvatar,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.thread.authorName,
                          style: AppTypography.labelLarge,
                        ),
                        Text(
                          widget.thread.authorUsername,
                          style: AppTypography.caption,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.thread.content,
                          style: AppTypography.bodyMedium,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.border),
            // Replies List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: _replies.length,
                itemBuilder: (context, index) {
                  final reply = _replies[index];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: CachedNetworkImageProvider(
                            reply.authorAvatar,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    reply.authorName,
                                    style: AppTypography.labelLarge,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    reply.authorUsername,
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reply.content,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(color: AppColors.border),
            // Reply Input
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Add a reply...',
                        hintStyle: AppTypography.caption,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: AppTypography.bodySmall,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_replyController.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reply posted!')),
                        );
                        _replyController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
