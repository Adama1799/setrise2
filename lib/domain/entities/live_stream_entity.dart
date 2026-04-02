// lib/domain/entities/live_stream_entity.dart
class LiveStreamEntity {
  final String id;
  final String hostId;
  final String hostName;
  final String hostUsername;
  final String hostAvatar;
  final String title;
  final String description;
  final String thumbnail;
  final int viewersCount;
  final DateTime startedAt;
  final bool isLive;
  final int duration;
  final int likes;
  final bool isLiked;

  LiveStreamEntity({
    required this.id,
    required this.hostId,
    required this.hostName,
    required this.hostUsername,
    required this.hostAvatar,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.viewersCount,
    required this.startedAt,
    required this.isLive,
    required this.duration,
    required this.likes,
    required this.isLiked,
  });
}
