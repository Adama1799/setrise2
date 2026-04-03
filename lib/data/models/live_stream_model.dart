// lib/data/models/live_stream_model.dart
import '../../domain/entities/live_stream_entity.dart';

class LiveStreamModel extends LiveStreamEntity {
  LiveStreamModel({
    required String id,
    required String hostId,
    required String hostName,
    required String hostUsername,
    required String hostAvatar,
    required String title,
    required String description,
    required String thumbnail,
    required int viewersCount,
    required DateTime startedAt,
    required bool isLive,
    required int duration,
    required int likes,
    required bool isLiked,
  }) : super(
    id: id,
    hostId: hostId,
    hostName: hostName,
    hostUsername: hostUsername,
    hostAvatar: hostAvatar,
    title: title,
    description: description,
    thumbnail: thumbnail,
    viewersCount: viewersCount,
    startedAt: startedAt,
    isLive: isLive,
    duration: duration,
    likes: likes,
    isLiked: isLiked,
  );

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      id: json['id'] ?? '',
      hostId: json['hostId'] ?? '',
      hostName: json['hostName'] ?? 'Host',
      hostUsername: json['hostUsername'] ?? '@host',
      hostAvatar: json['hostAvatar'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      viewersCount: json['viewersCount'] ?? 0,
      startedAt: DateTime.parse(json['startedAt'] ?? DateTime.now().toIso8601String()),
      isLive: json['isLive'] ?? true,
      duration: json['duration'] ?? 0,
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostId': hostId,
    'hostName': hostName,
    'hostUsername': hostUsername,
    'hostAvatar': hostAvatar,
    'title': title,
    'description': description,
    'thumbnail': thumbnail,
    'viewersCount': viewersCount,
    'startedAt': startedAt.toIso8601String(),
    'isLive': isLive,
    'duration': duration,
    'likes': likes,
    'isLiked': isLiked,
  };

  LiveStreamModel copyWith({
    String? id,
    String? hostId,
    String? hostName,
    String? hostUsername,
    String? hostAvatar,
    String? title,
    String? description,
    String? thumbnail,
    int? viewersCount,
    DateTime? startedAt,
    bool? isLive,
    int? duration,
    int? likes,
    bool? isLiked,
  }) {
    return LiveStreamModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostUsername: hostUsername ?? this.hostUsername,
      hostAvatar: hostAvatar ?? this.hostAvatar,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnail: thumbnail ?? this.thumbnail,
      viewersCount: viewersCount ?? this.viewersCount,
      startedAt: startedAt ?? this.startedAt,
      isLive: isLive ?? this.isLive,
      duration: duration ?? this.duration,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
