// lib/data/models/comment_model.dart
import '../../domain/entities/comment_entity.dart';

class CommentModel extends CommentEntity {
  CommentModel({
    required String id,
    required String authorId,
    required String authorName,
    required String authorUsername,
    required String authorAvatar,
    required String content,
    required DateTime createdAt,
    required int likes,
    required bool isLiked,
    required bool isOwn,
    required List<CommentModel> replies,
  }) : super(
    id: id,
    authorId: authorId,
    authorName: authorName,
    authorUsername: authorUsername,
    authorAvatar: authorAvatar,
    content: content,
    createdAt: createdAt,
    likes: likes,
    isLiked: isLiked,
    isOwn: isOwn,
    replies: replies,
  );

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? 'Unknown',
      authorUsername: json['authorUsername'] ?? '@user',
      authorAvatar: json['authorAvatar'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isOwn: json['isOwn'] ?? false,
      replies: (json['replies'] as List?)
          ?.map((e) => CommentModel.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorId': authorId,
    'authorName': authorName,
    'authorUsername': authorUsername,
    'authorAvatar': authorAvatar,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'isLiked': isLiked,
    'isOwn': isOwn,
    'replies': replies.map((e) => (e as CommentModel).toJson()).toList(),
  };

  CommentModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorUsername,
    String? authorAvatar,
    String? content,
    DateTime? createdAt,
    int? likes,
    bool? isLiked,
    bool? isOwn,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      isOwn: isOwn ?? this.isOwn,
      replies: replies ?? this.replies,
    );
  }
}
