import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class CreatePostBottomSheet extends StatefulWidget {
  final Function(String content, List<String> mediaUrls) onPost;
  const CreatePostBottomSheet({super.key, required this.onPost});
  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final _ctrl = TextEditingController();
  final List<String> _media = [];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _post() {
    if (_ctrl.text.trim().isEmpty) return;
    widget.onPost(_ctrl.text.trim(), _media);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'))),
            const Spacer(),
            const Text('New Post', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            const Spacer(),
            GestureDetector(onTap: _post,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: const Text('Post', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
          ]),
        ),
        const Divider(color: AppColors.border, height: 1),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const CircleAvatar(radius: 20, backgroundColor: AppColors.border, child: Icon(Icons.person, color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            Expanded(child: TextField(
              controller: _ctrl,
              maxLines: null,
              autofocus: true,
              style: AppTypography.bodyLarge,
              decoration: const InputDecoration(
                hintText: "What's happening?",
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textTertiary, fontFamily: 'Inter'),
              ),
            )),
          ]),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(children: [
            IconButton(icon: const Icon(Icons.image_outlined, color: AppColors.primary), onPressed: () {}),
            IconButton(icon: const Icon(Icons.gif_box_outlined, color: AppColors.primary), onPressed: () {}),
            IconButton(icon: const Icon(Icons.poll_outlined, color: AppColors.primary), onPressed: () {}),
            IconButton(icon: const Icon(Icons.location_on_outlined, color: AppColors.primary), onPressed: () {}),
          ]),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}
