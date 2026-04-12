// lib/features/stories/data/models/story_model.dart

import '../../domain/entities/story_entity.dart';

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.userId,
    required super.username,
    super.avatar,
    super.mediaUrl,
    super.mediaType,
    required super.status,
    required super.createdAt,
    required super.expiresAt,
    super.isLive,
    super.viewsCount,
    super.isViewed,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
      mediaUrl: json['media_url'] as String?,
      mediaType: _parseMediaType(json['media_type'] as String?),
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(
        json['expires_at'] as String? ??
            DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      ),
      isLive: json['is_live'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      isViewed: json['is_viewed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      if (avatar != null) 'avatar': avatar,
      if (mediaUrl != null) 'media_url': mediaUrl,
      'media_type': mediaType.name,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_live': isLive,
      'views_count': viewsCount,
      'is_viewed': isViewed,
    };
  }

  static StoryMediaType _parseMediaType(String? type) {
    switch (type) {
      case 'video':
        return StoryMediaType.video;
      default:
        return StoryMediaType.image;
    }
  }

  static StoryStatus _parseStatus(String? status) {
    switch (status) {
      case 'own':          return StoryStatus.own;
      case 'live':         return StoryStatus.live;
      case 'close_friend': return StoryStatus.closeFriend;
      case 'seen':         return StoryStatus.seen;
      default:             return StoryStatus.unseen;
    }
  }

  // ─── Mock Data ────────────────────────────────────────────────────────────

  static List<StoryModel> getMockStories() {
    final now = DateTime.now();
    final expires = now.add(const Duration(hours: 24));

    return [
      StoryModel(
        id: 'story_0',
        userId: 'me',
        username: 'Your Story',
        status: StoryStatus.own,
        createdAt: now,
        expiresAt: expires,
      ),
      StoryModel(
        id: 'story_1',
        userId: 'user_1',
        username: '@sara_live',
        status: StoryStatus.live,
        isLive: true,
        createdAt: now,
        expiresAt: expires,
      ),
      StoryModel(
        id: 'story_2',
        userId: 'user_2',
        username: '@ahmed_99',
        status: StoryStatus.closeFriend,
        createdAt: now.subtract(const Duration(hours: 2)),
        expiresAt: expires,
      ),
      StoryModel(
        id: 'story_3',
        userId: 'user_3',
        username: '@nora_m',
        status: StoryStatus.unseen,
        createdAt: now.subtract(const Duration(hours: 5)),
        expiresAt: expires,
      ),
      StoryModel(
        id: 'story_4',
        userId: 'user_4',
        username: '@khalid_x',
        status: StoryStatus.unseen,
        createdAt: now.subtract(const Duration(hours: 8)),
        expiresAt: expires,
      ),
      StoryModel(
        id: 'story_5',
        userId: 'user_5',
        username: '@layla_23',
        status: StoryStatus.seen,
        createdAt: now.subtract(const Duration(hours: 12)),
        expiresAt: expires,
      ),
    ];
  }
}
