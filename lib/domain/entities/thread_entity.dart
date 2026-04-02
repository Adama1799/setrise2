// lib/domain/entities/thread_entity.dart (Updated)
class ThreadEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String authorUsername;
  final String authorAvatar;
  final String content;
  final String? mediaUrl; // 1000x650/700px vertical
  final DateTime createdAt;
  final int likes;
  final int replies;
  final int reposts;
  final bool isLiked;
  final bool isReposted;
  final ThreadEntity? replyTo;
  final List<ThreadEntity> threadReplies;
  final bool hasMoreReplies;

  ThreadEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatar,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
    required this.likes,
    required this.replies,
    required this.reposts,
    required this.isLiked,
    required this.isReposted,
    this.replyTo,
    required this.threadReplies,
    required this.hasMoreReplies,
  });
}
