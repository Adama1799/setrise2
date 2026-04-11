import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../data/models/post_model.dart';

class CommentsSheet extends StatefulWidget {
  final PostModel post;
  const CommentsSheet({super.key, required this.post});
  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final _ctrl = TextEditingController();
  final List<Map<String, dynamic>> _comments = [
    {'user': 'ahmed_99', 'text': 'Amazing post! 🔥', 'time': '2m', 'likes': 24},
    {'user': 'sara_x', 'text': 'Love this content ❤️', 'time': '5m', 'likes': 18},
    {'user': 'nora_m', 'text': 'Keep it up! 💯', 'time': '8m', 'likes': 7},
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _send() {
    if (_ctrl.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(0, {'user': 'me', 'text': _ctrl.text.trim(), 'time': 'now', 'likes': 0});
      _ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        Text('Comments', style: AppTypography.h3),
        const Divider(color: AppColors.border),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _comments.length,
          itemBuilder: (_, i) {
            final c = _comments[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CircleAvatar(radius: 18, backgroundColor: AppColors.border, child: Icon(Icons.person, color: AppColors.textSecondary, size: 18)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(c['user'], style: AppTypography.labelMedium),
                    const SizedBox(width: 8),
                    Text(c['time'], style: AppTypography.caption),
                  ]),
                  const SizedBox(height: 4),
                  Text(c['text'], style: AppTypography.bodySmall),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.favorite_border, size: 14, color: AppColors.textTertiary),
                    const SizedBox(width: 4),
                    Text('${c['likes']}', style: AppTypography.caption),
                    const SizedBox(width: 16),
                    Text('Reply', style: AppTypography.caption.copyWith(fontWeight: FontWeight.w600)),
                  ]),
                ])),
              ]),
            );
          },
        )),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _ctrl,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: AppTypography.caption,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            )),
            const SizedBox(width: 8),
            GestureDetector(onTap: _send,
              child: Container(width: 42, height: 42, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: AppColors.white, size: 18))),
          ]),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}
