// lib/data/models/dating_profile_model.dart
import '../../domain/entities/dating_profile_entity.dart';

class DatingProfileModel extends DatingProfileEntity {
  DatingProfileModel({
    required String id,
    required String userId,
    required String name,
    required String age,
    required List<String> photos,
    required String bio,
    required String location,
    required List<String> interests,
    required String lookingFor,
    required bool isOnline,
    required DateTime lastSeen,
  }) : super(
    id: id,
    userId: userId,
    name: name,
    age: age,
    photos: photos,
    bio: bio,
    location: location,
    interests: interests,
    lookingFor: lookingFor,
    isOnline: isOnline,
    lastSeen: lastSeen,
  );

  factory DatingProfileModel.fromJson(Map<String, dynamic> json) {
    return DatingProfileModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? '',
      photos: List<String>.from(json['photos'] ?? []),
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      lookingFor: json['lookingFor'] ?? '',
      isOnline: json['isOnline'] ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'age': age,
    'photos': photos,
    'bio': bio,
    'location': location,
    'interests': interests,
    'lookingFor': lookingFor,
    'isOnline': isOnline,
    'lastSeen': lastSeen.toIso8601String(),
  };

  DatingProfileModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? age,
    List<String>? photos,
    String? bio,
    String? location,
    List<String>? interests,
    String? lookingFor,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return DatingProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      photos: photos ?? this.photos,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      lookingFor: lookingFor ?? this.lookingFor,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
