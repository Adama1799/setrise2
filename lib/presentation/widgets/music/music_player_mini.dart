import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/music_track_model.dart';

class MusicPlayerMini extends StatelessWidget {
  final MusicTrackModel track;
  const MusicPlayerMini({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.musicColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.musicColor.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.musicColor, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.music_note, color: Colors.white, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(track.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter'), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(track.artist, style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontFamily: 'Inter')),
        ])),
        IconButton(icon: const Icon(Icons.skip_previous), onPressed: () {}, color: AppColors.musicColor),
        Container(width: 38, height: 38, decoration: const BoxDecoration(color: AppColors.musicColor, shape: BoxShape.circle),
          child: const Icon(Icons.pause, color: Colors.white, size: 20)),
        IconButton(icon: const Icon(Icons.skip_next), onPressed: () {}, color: AppColors.musicColor),
      ]),
    );
  }
}
