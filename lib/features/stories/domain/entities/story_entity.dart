here// lib/features/stories/domain/entities/story_entity.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

enum StoryStatus {
  own,         // 🟢 قصتك
  live,        // 🔴 لايف
  closeFriend, // 🟠 صديق مقرب
  unseen,      // 🟡 لم تُفتح
  seen,        // ⚪ مشاهدة
}

enum StoryMediaType {
  image,
  video,
}

class StoryEntity {
  final String id;
  final String userId;
  final String username;
  final String? avatar;
  final String? mediaUrl;
  final StoryMediaType mediaType;
  final StoryStatus status;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isLive;
  final int viewsCount;
  final bool isViewed;

  const StoryEntity({
    required this.id,
    required this.userId,
    required this.username,
    this.avatar,
    this.mediaUrl,
    this.mediaType = StoryMediaType.image,
    required this.status,
    required this.createdAt,
    required this.expiresAt,
    this.isLive = false,
    this.viewsCount = 0,
    this.isViewed = false,
  });

  Color get borderColor {
    switch (status) {
      case StoryStatus.own:         return AppColors.storyOwn;
      case StoryStatus.live:        return AppColors.storyLive;
      case StoryStatus.closeFriend: return AppColors.storyCloseFriend;
      case StoryStatus.unseen:      return AppColors.storyUnseen;
      case StoryStatus.seen:        return AppColors.storySeen;
    }
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  StoryEntity copyWith({
    String? id,
    String? userId,
    String? username,
    String? avatar,
    String? mediaUrl,
    StoryMediaType? mediaType,
    StoryStatus? status,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isLive,
    int? viewsCount,
    bool? isViewed,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isLive: isLive ?? this.isLive,
      viewsCount: viewsCount ?? this.viewsCount,
      isViewed: isViewed ?? this.isViewed,
    );
  }
}
