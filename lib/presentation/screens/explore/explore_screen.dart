// lib/presentation/screens/explore/explore_screen.dart
// FIX: Was an empty file — completed
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});
  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _ctrl = TextEditingController();
  String _query = '';

  final List<Map<String, dynamic>> _trending = [
    {'tag': '#setrise', 'posts': '2.4M', 'emoji': '🔥'},
    {'tag': '#viral', 'posts': '1.8M', 'emoji': '⚡'},
    {'tag': '#tech2025', 'posts': '980K', 'emoji': '💻'},
    {'tag': '#musiclive', 'posts': '750K', 'emoji': '🎵'},
    {'tag': '#dating', 'posts': '620K', 'emoji': '❤️'},
    {'tag': '#shop', 'posts': '510K', 'emoji': '🛍'},
  ];

  final List<Map<String, String>> _categories = [
    {'label': 'For You', 'emoji': '✨'},
    {'label': 'Trending', 'emoji': '🔥'},
    {'label': 'Music', 'emoji': '🎵'},
    {'label': 'Sports', 'emoji': '⚽'},
    {'label': 'Tech', 'emoji': '💻'},
    {'label': 'Art', 'emoji': '🎨'},
  ];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background, elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(children: [
            const Icon(Icons.search, color: AppColors.textTertiary, size: 18),
            const SizedBox(width: 8),
            Expanded(child: TextField(
              controller: _ctrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Search SetRise...',
                border: InputBorder.none,
                isDense: true,
              ),
              style: AppTypography.bodySmall,
            )),
          ]),
        ),
      ),
      body: _query.isEmpty ? _buildDiscover() : _buildResults(),
    );
  }

  Widget _buildDiscover() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Category chips
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (_, i) {
              final cat = _categories[i];
              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: i == 0 ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: i == 0 ? AppColors.primary : AppColors.border),
                ),
                child: Text('${cat['emoji']} ${cat['label']}',
                  style: TextStyle(
                    fontFamily: 'Inter', fontWeight: FontWeight.w600,
                    color: i == 0 ? AppColors.white : AppColors.textPrimary,
                    fontSize: 13,
                  )),
              );
            },
          ),
        ),

        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Trending Now', style: AppTypography.h3),
        ),
        const SizedBox(height: 12),
        ..._trending.map((t) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(t['emoji'], style: const TextStyle(fontSize: 22))),
          ),
          title: Text(t['tag'], style: AppTypography.labelLarge),
          subtitle: Text('${t['posts']} posts', style: AppTypography.caption),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.textTertiary),
          onTap: () {},
        )),

        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Suggested Users', style: AppTypography.h3),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 8,
            itemBuilder: (_, i) => Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(children: [
                CircleAvatar(radius: 28, backgroundColor: AppColors.primary.withOpacity(0.1 + i * 0.05),
                  child: Icon(Icons.person, color: AppColors.primary, size: 28)),
                const SizedBox(height: 6),
                Text('User ${i + 1}', style: AppTypography.caption,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text('Follow', style: AppTypography.caption.copyWith(fontSize: 10)),
                ),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _buildResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      itemBuilder: (_, i) => ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.border,
          child: Icon(Icons.person, color: AppColors.textSecondary),
        ),
        title: Text('Result for "$_query" ${i + 1}', style: AppTypography.labelLarge),
        subtitle: Text('${(i + 1) * 1200} followers', style: AppTypography.caption),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(20)),
          child: Text('Follow', style: AppTypography.labelSmall),
        ),
        onTap: () {},
      ),
    );
  }
}
