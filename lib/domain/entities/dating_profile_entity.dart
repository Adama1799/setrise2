// lib/domain/entities/dating_profile_entity.dart
class DatingProfileEntity {
  final String id;
  final String userId;
  final String name;
  final String age;
  final List<String> photos;
  final String bio;
  final String location;
  final List<String> interests;
  final String lookingFor;
  final bool isOnline;
  final DateTime lastSeen;

  DatingProfileEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.photos,
    required this.bio,
    required this.location,
    required this.interests,
    required this.lookingFor,
    required this.isOnline,
    required this.lastSeen,
  });
}
