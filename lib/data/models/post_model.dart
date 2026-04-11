import 'package:equatable/equatable.dart';

class PostModel extends Equatable {
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
  final bool isLiked;
  final bool isBookmarked;
  final String location;
  final List<String> tags;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorUsername,
    required this.authorAvatar,
    required this.content,
    required this.mediaUrls,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    this.location = '',
    this.tags = const [],
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      authorId: json['author_id'] ?? '',
      authorName: json['author_name'] ?? '',
      authorUsername: json['author_username'] ?? '',
      authorAvatar: json['author_avatar'] ?? '',
      content: json['content'] ?? '',
      mediaUrls: List<String>.from(json['media_urls'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      likes: json['likes']?.toInt() ?? 0,
      comments: json['comments']?.toInt() ?? 0,
      shares: json['shares']?.toInt() ?? 0,      isLiked: json['is_liked'] ?? false,
      isBookmarked: json['is_bookmarked'] ?? false,
      location: json['location'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author_id': authorId,
      'author_name': authorName,
      'author_username': authorUsername,
      'author_avatar': authorAvatar,
      'content': content,
      'media_urls': mediaUrls,
      'created_at': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'is_liked': isLiked,
      'is_bookmarked': isBookmarked,
      'location': location,
      'tags': tags,
    };
  }

  PostModel copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorUsername,
    String? authorAvatar,
    String? content,
    List<String>? mediaUrls,
    DateTime? createdAt,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    bool? isBookmarked,
    String? location,
    List<String>? tags,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUsername: authorUsername ?? this.authorUsername,
      authorAvatar: authorAvatar ?? this.authorAvatar,      content: content ?? this.content,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      location: location ?? this.location,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
    id, authorId, authorName, authorUsername, authorAvatar, 
    content, mediaUrls, createdAt, likes, comments, 
    shares, isLiked, isBookmarked, location, tags
  ];
}
