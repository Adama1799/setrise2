
// lib/presentation/widgets/live/live_viewers_list.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/live_stream_model.dart';

class LiveViewersList extends StatelessWidget {
  final LiveStreamModel stream;

  const LiveViewersList({
    super.key,
    required this.stream,
  });

  @override
  Widget build(BuildContext context) {
    final viewers = List.generate(
      10,
      (i) => {
        'id': '$i',
        'name': 'Viewer ${i + 1}',
        'username': '@viewer${i + 1}',
        'avatar': 'https://i.pravatar.cc/150?img=${i + 10}',
      },
    );

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            '${Formatters.formatNumber(stream.viewersCount)} Watching',
            style: AppTypography.labelLarge,
          ),
        ),
        ...viewers.map((viewer) => ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(viewer['avatar']),
          ),
          title: Text(viewer['name'], style: AppTypography.labelMedium),
          subtitle: Text(viewer['username'], style: AppTypography.caption),
          trailing: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text(
              'Follow',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: 'Inter',
              ),
            ),
          ),
        )),
      ],
    );
  }
}
