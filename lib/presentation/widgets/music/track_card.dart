// lib/presentation/widgets/music/track_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/formatters.dart';
import '../../../data/models/music_track_model.dart';

class TrackCard extends StatelessWidget {
  final MusicTrackModel track;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;

  const TrackCard({
    super.key,
    required this.track,
    required this.onTap,
    required this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: track.albumCover,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            track.title,
            style: AppTypography.labelLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            track.artist,
            style: AppTypography.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  track.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: track.isLiked ? AppColors.music : AppColors.textTertiary,
                  size: 20,
                ),
                onPressed: onLikeTap,
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.music,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
