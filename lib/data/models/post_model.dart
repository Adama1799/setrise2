import 'package:flutter/material.dart';

class PostModel {
  final String id;
  final String userId;
  final String username;
  final String? userAvatar;
  final String title;
  final String? hashtags;
  final String? mediaUrl;
  final bool isVideo;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int sendsCount;
  final int savesCount;
  final int viewsCount;
  final bool isLiked;
  final bool isCommented;
  final bool isShared;
  final bool isSent;
  final bool isSaved;
  final bool isFollowing;
  final bool isPlaying;
  final DateTime createdAt;
  final Color backgroundColor;

  PostModel({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatar,
    required this.title,
    this.hashtags,
    this.mediaUrl,
    this.isVideo = true,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.sendsCount,
    required this.savesCount,
    required this.viewsCount,
    this.isLiked = false,
    this.isCommented = false,
    this.isShared = false,
    this.isSent = false,
    this.isSaved = false,
    this.isFollowing = false,
    this.isPlaying = true,
    required this.createdAt,
    required this.backgroundColor,
  });

  PostModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userAvatar,
    String? title,
    String? hashtags,
    String? mediaUrl,
    bool? isVideo,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    int? sendsCount,
    int? savesCount,
    int? viewsCount,
    bool? isLiked,
    bool? isCommented,
    bool? isShared,
    bool? isSent,
    bool? isSaved,
    bool? isFollowing,
    bool? isPlaying,
    DateTime? createdAt,
    Color? backgroundColor,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      title: title ?? this.title,
      hashtags: hashtags ?? this.hashtags,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      isVideo: isVideo ?? this.isVideo,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      sendsCount: sendsCount ?? this.sendsCount,
      savesCount: savesCount ?? this.savesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      isLiked: isLiked ?? this.isLiked,
      isCommented: isCommented ?? this.isCommented,
      isShared: isShared ?? this.isShared,
      isSent: isSent ?? this.isSent,
      isSaved: isSaved ?? this.isSaved,
      isFollowing: isFollowing ?? this.isFollowing,
      isPlaying: isPlaying ?? this.isPlaying,
      createdAt: createdAt ?? this.createdAt,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }

  // Mock Data Generator
  static List<PostModel> getMockPosts() {
    final colors = [
      const Color(0xFF1A0A2E),
      const Color(0xFF0A1628),
      const Color(0xFF1A0A0A),
      const Color(0xFF0A1A0A),
      const Color(0xFF1A1A0A),
    ];

    return List.generate(
      20,
      (i) => PostModel(
        id: 'post_$i',
        userId: 'user_$i',
        username: '@user_$i',
        title: 'Amazing content title that grabs attention right away #$i',
        hashtags: '#trending #explore #setrise #viral',
        likesCount: (i + 1) * 1200,
        commentsCount: (i + 1) * 340,
        sharesCount: (i + 1) * 210,
        sendsCount: (i + 1) * 100,
        savesCount: (i + 1) * 510,
        viewsCount: (i + 1) * 5000,
        createdAt: DateTime.now().subtract(Duration(hours: i)),
        backgroundColor: colors[i % colors.length],
      ),
    );
  }
}
