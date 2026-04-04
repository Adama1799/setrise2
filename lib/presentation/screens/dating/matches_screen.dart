import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../providers/dating_provider.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(datingProvider).matches;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Matches 💛', style: AppTypography.h2),
        centerTitle: true,
      ),
      body: matches.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('💛', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text('No matches yet', style: AppTypography.h3),
              const SizedBox(height: 8),
              Text('Keep swiping!', style: AppTypography.caption),
            ]))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.75),
              itemCount: matches.length,
              itemBuilder: (_, i) {
                final m = matches[i];
                return Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.surface,
                    boxShadow: [BoxShadow(color: AppColors.black.withOpacity(0.08), blurRadius: 10)]),
                  child: Column(children: [
                    Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(m.photos.isNotEmpty ? m.photos[0] : '', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.border, child: const Icon(Icons.person, size: 60, color: AppColors.textTertiary))))),
                    Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('${m.name}, ${m.age}', style: AppTypography.labelLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(m.location, style: AppTypography.caption),
                      const SizedBox(height: 6),
                      SizedBox(width: double.infinity, height: 32,
                        child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: AppColors.dateColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          onPressed: () {}, child: const Text('Message', style: TextStyle(color: AppColors.white, fontSize: 12, fontFamily: 'Inter')))),
                    ])),
                  ]),
                );
              },
            ),
    );
  }
}
