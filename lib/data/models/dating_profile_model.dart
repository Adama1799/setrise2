// lib/data/models/dating_profile_model.dart
import 'dart:math';

class DatingProfileModel {
  final String id;
  final String name;
  final int age;
  final String city;
  final String distance;
  final String bio;
  final List<String> imageUrls;
  final List<String> interests;
  final bool isVerified;

  DatingProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.distance,
    required this.bio,
    required this.imageUrls,
    required this.interests,
    this.isVerified = false,
  });

  static List<DatingProfileModel> getMockProfiles() {
    final random = Random();
    return [
      DatingProfileModel(
        id: 'd1',
        name: 'Sarah',
        age: 24,
        city: 'Algiers',
        distance: '12 km',
        bio: 'Coffee lover ☕ · Traveler ✈️ · Dog mom 🐕',
        imageUrls: [
          'https://picsum.photos/400/600?random=1',
          'https://picsum.photos/400/600?random=2',
          'https://picsum.photos/400/600?random=3',
        ],
        interests: ['Travel', 'Photography', 'Music'],
        isVerified: true,
      ),
      DatingProfileModel(
        id: 'd2',
        name: 'Nora',
        age: 22,
        city: 'Oran',
        distance: '45 km',
        bio: 'Artist 🎨 · Book lover 📚 · Looking for real connection',
        imageUrls: [
          'https://picsum.photos/400/600?random=4',
          'https://picsum.photos/400/600?random=5',
        ],
        interests: ['Art', 'Books', 'Cooking'],
        isVerified: false,
      ),
      DatingProfileModel(
        id: 'd3',
        name: 'Lina',
        age: 26,
        city: 'Paris',
        distance: '102 km',
        bio: 'Software engineer 💻 · Gym addict 🏋️ · Foodie 🍜',
        imageUrls: [
          'https://picsum.photos/400/600?random=6',
          'https://picsum.photos/400/600?random=7',
        ],
        interests: ['Tech', 'Fitness', 'Food'],
        isVerified: true,
      ),
      DatingProfileModel(
        id: 'd4',
        name: 'Rania',
        age: 23,
        city: 'Cairo',
        distance: '230 km',
        bio: 'Architecture student 🏛️ · Night owl 🌙 · Anime fan 🎌',
        imageUrls: [
          'https://picsum.photos/400/600?random=8',
          'https://picsum.photos/400/600?random=9',
        ],
        interests: ['Design', 'Anime', 'Gaming'],
        isVerified: false,
      ),
      DatingProfileModel(
        id: 'd5',
        name: 'Hana',
        age: 25,
        city: 'Dubai',
        distance: '890 km',
        bio: 'Entrepreneur 💼 · Pilot in training ✈️ · Sunset chaser 🌅',
        imageUrls: [
          'https://picsum.photos/400/600?random=10',
          'https://picsum.photos/400/600?random=11',
          'https://picsum.photos/400/600?random=12',
        ],
        interests: ['Business', 'Travel', 'Sports'],
        isVerified: true,
      ),
    ];
  }
}
