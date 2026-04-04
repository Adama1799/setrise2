import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/thread_model.dart';

class ReplyThreadSheet extends StatefulWidget {
  final ThreadModel thread;
  final Function(String content) onReply;
  const ReplyThreadSheet({super.key, required this.thread, required this.onReply});
  @override
  State<ReplyThreadSheet> createState() => _ReplyThreadSheetState();
}

class _ReplyThreadSheetState extends State<ReplyThreadSheet> {
  final _ctrl = TextEditingController();
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _reply() {
    if (_ctrl.text.trim().isEmpty) return;
    widget.onReply(_ctrl.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontFamily: 'Inter'))),
            const Spacer(),
            const Text('Reply', style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Inter')),
            const Spacer(),
            GestureDetector(onTap: _reply,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(20)),
                child: const Text('Reply', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')))),
          ]),
        ),
        const Divider(color: AppColors.border),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const CircleAvatar(radius: 18, backgroundColor: AppColors.border, child: Icon(Icons.person, color: AppColors.textSecondary, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: TextField(
              controller: _ctrl, autofocus: true, maxLines: null,
              decoration: const InputDecoration(hintText: 'Write your reply...', border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textTertiary, fontFamily: 'Inter')),
            )),
          ]),
        ),
        const Spacer(),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ]),
    );
  }
}
