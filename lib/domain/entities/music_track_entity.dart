// lib/domain/entities/music_track_entity.dart
class MusicTrackEntity {
  final String id;
  final String title;
  final String artist;
  final String albumCover;
  final String audioUrl;
  final int duration;
  final int plays;
  final int likes;
  final bool isLiked;
  final bool isFavorite;
  final String genre;

  MusicTrackEntity({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.audioUrl,
    required this.duration,
    required this.plays,
    required this.likes,
    required this.isLiked,
    required this.isFavorite,
    required this.genre,
  });
}
