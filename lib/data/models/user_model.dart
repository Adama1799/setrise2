// lib/data/models/user_model.dart
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String name,
    required String username,
    required String email,
    required String avatar,
    required String bio,
    required String coverImage,
    required int followers,
    required int following,
    required int postsCount,
    required bool isFollowing,
    required bool isVerified,
    required DateTime createdAt,
  }) : super(
    id: id,
    name: name,
    username: username,
    email: email,
    avatar: avatar,
    bio: bio,
    coverImage: coverImage,
    followers: followers,
    following: following,
    postsCount: postsCount,
    isFollowing: isFollowing,
    isVerified: isVerified,
    createdAt: createdAt,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'User',
      username: json['username'] ?? '@user',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      coverImage: json['coverImage'] ?? '',
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      postsCount: json['postsCount'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'username': username,
    'email': email,
    'avatar': avatar,
    'bio': bio,
    'coverImage': coverImage,
    'followers': followers,
    'following': following,
    'postsCount': postsCount,
    'isFollowing': isFollowing,
    'isVerified': isVerified,
    'createdAt': createdAt.toIso8601String(),
  };

  UserModel copyWith({
    String? id,
    String? name,
    String? username,
    String? email,
    String? avatar,
    String? bio,
    String? coverImage,
    int? followers,
    int? following,
    int? postsCount,
    bool? isFollowing,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      coverImage: coverImage ?? this.coverImage,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      postsCount: postsCount ?? this.postsCount,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
