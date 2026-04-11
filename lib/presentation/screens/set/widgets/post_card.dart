import 'package:flutter/material.dart';
import 'dart:math' show cos, sin, pi;

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/post_model.dart';
import 'post_info_sheet.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final Function(PostModel) onUpdate;
  final VoidCallback onSwipeNext;

  const PostCard({
    super.key,
    required this.post,
    required this.onUpdate,
    required this.onSwipeNext,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with SingleTickerProviderStateMixin {

  Color get _accent {
    final hsl = HSLColor.fromColor(widget.post.backgroundColor);
    return hsl.withSaturation(1).withLightness(0.6).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [

        // BACKGROUND
        Container(color: widget.post.backgroundColor),

        // INFO BUTTON (TOP RIGHT)
        SafeArea(
          child: Positioned(
            top: 10,
            right: 12,
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => PostInfoSheet(
                    post: widget.post,
                    accent: _accent,
                  ),
                );
              },
            ),
          ),
        ),

        // CENTER PLAY
        if (!widget.post.isPlaying)
          const Center(
            child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
          ),

        // RIGHT ACTIONS (TikTok style)
        Positioned(
          right: 10,
          bottom: 120,
          child: Column(
            children: [
              _icon(Icons.favorite, widget.post.likesCount),
              _icon(Icons.comment, widget.post.commentsCount),
              _icon(Icons.share, widget.post.sharesCount),
            ],
          ),
        ),

        // BOTTOM INFO (TikTok style)
        Positioned(
          left: 12,
          right: 80,
          bottom: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // USER + FOLLOW + MESSAGE
              Row(
                children: [
                  Text(
                    widget.post.username,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),

                  _btn("Follow"),
                  const SizedBox(width: 6),
                  _btn("Message"),
                ],
              ),

              const SizedBox(height: 8),

              // TITLE
              Text(widget.post.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),

              const SizedBox(height: 6),

              // DESCRIPTION
              Text(widget.post.description ?? "",
                  style: const TextStyle(color: Colors.white70)),

              const SizedBox(height: 6),

              // HASHTAGS
              Text(widget.post.hashtags ?? "",
                  style: const TextStyle(color: Colors.blueAccent)),

              const SizedBox(height: 10),

              // MUSIC
              Row(
                children: const [
                  Icon(Icons.music_note, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text("Original Audio",
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _btn(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 12)),
      );

  Widget _icon(IconData i, int count) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Icon(i, color: Colors.white, size: 30),
            const SizedBox(height: 4),
            Text(
              Formatters.formatCount(count),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            )
          ],
        ),
      );
}
