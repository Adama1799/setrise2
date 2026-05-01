// lib/presentation/screens/shop/product/widgets/qna_section.dart
import 'package:flutter/cupertino.dart';
import '../../../../../core/theme/app_colors.dart';

class QnaSection extends StatelessWidget {
  final List<Map<String, String>> questions;
  const QnaSection({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Questions & Answers', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...questions.map((q) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(CupertinoIcons.question_circle, color: AppColors.accent, size: 18), const SizedBox(width: 8), Expanded(child: Text(q['question']!, style: const TextStyle(color: AppColors.white))) ]),
            const SizedBox(height: 8),
            Text(q['answer'] ?? 'No answer yet', style: const TextStyle(color: AppColors.grey2)),
          ]),
        )),
      ]),
    );
  }
}
