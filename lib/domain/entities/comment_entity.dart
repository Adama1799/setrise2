// lib/domain/entities/comment_entity.dart
class CommentEntity {
  final String id;
  final String authorId;
  final String authorName;
  final String authorUsername;
  final String authorAvatar;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final bool isOwn;
  final List<CommentEntity> replies;

  CommentEntity({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatar,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.isLiked,
    required this.isOwn,
    required this.replies,
  });
}
