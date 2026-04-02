// lib/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String name;
  final String username;
  final String email;
  final String avatar;
  final String bio;
  final String coverImage;
  final int followers;
  final int following;
  final int postsCount;
  final bool isFollowing;
  final bool isVerified;
  final DateTime createdAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    required this.bio,
    required this.coverImage,
    required this.followers,
    required this.following,
    required this.postsCount,
    required this.isFollowing,
    required this.isVerified,
    required this.createdAt,
  });
}
