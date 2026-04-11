hereimport 'package:flutter/material.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/post_model.dart';

class PostInfoSheet extends StatelessWidget {
  final PostModel post;
  final Color accent;

  const PostInfoSheet({
    super.key,
    required this.post,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text("About Post",
              style: AppTextStyles.h5.copyWith(color: Colors.white)),

          const SizedBox(height: 16),

          _row("Creator", post.username),
          _row("Title", post.title),
          _row("Description", post.description ?? "No description"),
          _row("Category", post.hashtags ?? "General"),
          _row("Music", "Original Audio"),

          const SizedBox(height: 20),

          Row(
            children: [
              _action("Follow"),
              const SizedBox(width: 10),
              _action("Message"),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _row(String t, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(t, style: const TextStyle(color: Colors.white54)),
            const Spacer(),
            Flexible(
              child: Text(v,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white)),
            )
          ],
        ),
      );

  Widget _action(String t) => Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: accent),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(t, style: TextStyle(color: accent)),
        ),
      );
}
