import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum StoryStatus {
  own,        // 🟢 Your story
  live,       // 🔴 Live
  closeFriend,// 🟠 Close friend
  unseen,     // 🟡 Not opened
  seen,       // ⚪ Viewed
}

class StoryModel {
  final String id;
  final String userId;
  final String username;
  final String? avatar;
  final StoryStatus status;
  final DateTime createdAt;
  final bool isLive;

  StoryModel({
    required this.id,
    required this.userId,
    required this.username,
    this.avatar,
    required this.status,
    required this.createdAt,
    this.isLive = false,
  });

  Color get borderColor {
    switch (status) {
      case StoryStatus.own:
        return AppColors.storyOwn;
      case StoryStatus.live:
        return AppColors.storyLive;
      case StoryStatus.closeFriend:
        return AppColors.storyCloseFriend;
      case StoryStatus.unseen:
        return AppColors.storyUnseen;
      case StoryStatus.seen:
        return AppColors.storySeen;
    }
  }

  // Mock Data
  static List<StoryModel> getMockStories() {
    return [
      StoryModel(
        id: 'story_0',
        userId: 'me',
        username: 'Your Story',
        status: StoryStatus.own,
        createdAt: DateTime.now(),
      ),
      StoryModel(
        id: 'story_1',
        userId: 'user_1',
        username: '@sara_live',
        status: StoryStatus.live,
        isLive: true,
        createdAt: DateTime.now(),
      ),
      StoryModel(
        id: 'story_2',
        userId: 'user_2',
        username: '@ahmed_99',
        status: StoryStatus.closeFriend,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      StoryModel(
        id: 'story_3',
        userId: 'user_3',
        username: '@nora_m',
        status: StoryStatus.unseen,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      StoryModel(
        id: 'story_4',
        userId: 'user_4',
        username: '@khalid_x',
        status: StoryStatus.unseen,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      StoryModel(
        id: 'story_5',
        userId: 'user_5',
        username: '@layla_23',
        status: StoryStatus.seen,
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ];
  }
}
