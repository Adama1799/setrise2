import '../../domain/entities/thread_entity.dart';

class ThreadModel extends ThreadEntity {
  ThreadModel({
    required String id,
    required String authorId,
    required String authorName,
    required String authorUsername,
    required String authorAvatar,
    required String content,
    String? mediaUrl,
    required DateTime createdAt,
    required int likes,
    required int replies,
    required int reposts,
    required bool isLiked,
    required bool isReposted,
    ThreadModel? replyTo,
    required List<ThreadModel> threadReplies,
    bool hasMoreReplies = false,
  }) : super(
    id: id, authorId: authorId, authorName: authorName,
    authorUsername: authorUsername, authorAvatar: authorAvatar,
    content: content, mediaUrl: mediaUrl, createdAt: createdAt,
    likes: likes, replies: replies, reposts: reposts,
    isLiked: isLiked, isReposted: isReposted,
    replyTo: replyTo, threadReplies: threadReplies,
    hasMoreReplies: hasMoreReplies,
  );

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      id: json['id'] ?? '',
      authorId: json['authorId'] ?? '',
      authorName: json['authorName'] ?? 'Unknown',
      authorUsername: json['authorUsername'] ?? '@user',
      authorAvatar: json['authorAvatar'] ?? '',
      content: json['content'] ?? '',
      mediaUrl: json['mediaUrl'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      replies: json['replies'] ?? 0,
      reposts: json['reposts'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isReposted: json['isReposted'] ?? false,
      replyTo: json['replyTo'] != null ? ThreadModel.fromJson(json['replyTo']) : null,
      threadReplies: (json['threadReplies'] as List?)?.map((e) => ThreadModel.fromJson(e)).toList() ?? [],
      hasMoreReplies: json['hasMoreReplies'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'authorId': authorId, 'authorName': authorName,
    'authorUsername': authorUsername, 'authorAvatar': authorAvatar,
    'content': content, 'mediaUrl': mediaUrl,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes, 'replies': replies, 'reposts': reposts,
    'isLiked': isLiked, 'isReposted': isReposted,
    'replyTo': replyTo != null ? (replyTo as ThreadModel).toJson() : null,
    'threadReplies': threadReplies.map((e) => (e as ThreadModel).toJson()).toList(),
    'hasMoreReplies': hasMoreReplies,
  };

  ThreadModel copyWith({
    String? id, String? authorId, String? authorName, String? authorUsername,
    String? authorAvatar, String? content, String? mediaUrl, DateTime? createdAt,
    int? likes, int? replies, int? reposts, bool? isLiked, bool? isReposted,
    ThreadModel? replyTo, List<ThreadModel>? threadReplies, bool? hasMoreReplies,
  }) {
    return ThreadModel(
      id: id ?? this.id, authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content, mediaUrl: mediaUrl ?? this.mediaUrl,
      createdAt: createdAt ?? this.createdAt, likes: likes ?? this.likes,
      replies: replies ?? this.replies, reposts: reposts ?? this.reposts,
      isLiked: isLiked ?? this.isLiked, isReposted: isReposted ?? this.isReposted,
      replyTo: replyTo ?? this.replyTo,
      threadReplies: threadReplies ?? this.threadReplies,
      hasMoreReplies: hasMoreReplies ?? this.hasMoreReplies,
    );
  }
}
