// lib/domain/entities/post_entity.dart
class PostEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String authorUsername;
  final String authorAvatar;
  final String content;
  final List<String> mediaUrls;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int shares;
  final int saves;
  final bool isLiked;
  final bool isShared;
  final bool isSaved;
  final bool isFollowing;
  final List<String> mentionedUsers;
  final List<String> hashtags;

  PostEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatar,
    required this.content,
    required this.mediaUrls,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.saves,
    required this.isLiked,
    required this.isShared,
    required this.isSaved,
    required this.isFollowing,
    required this.mentionedUsers,
    required this.hashtags,
  });
}
