// lib/data/models/music_track_model.dart
import '../../domain/entities/music_track_entity.dart';

class MusicTrackModel extends MusicTrackEntity {
  MusicTrackModel({
    required String id,
    required String title,
    required String artist,
    required String albumCover,
    required String audioUrl,
    required int duration,
    required int plays,
    required int likes,
    required bool isLiked,
    required bool isFavorite,
    required String genre,
  }) : super(
    id: id,
    title: title,
    artist: artist,
    albumCover: albumCover,
    audioUrl: audioUrl,
    duration: duration,
    plays: plays,
    likes: likes,
    isLiked: isLiked,
    isFavorite: isFavorite,
    genre: genre,
  );

  factory MusicTrackModel.fromJson(Map<String, dynamic> json) {
    return MusicTrackModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      albumCover: json['albumCover'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      duration: json['duration'] ?? 0,
      plays: json['plays'] ?? 0,
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      genre: json['genre'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'albumCover': albumCover,
    'audioUrl': audioUrl,
    'duration': duration,
    'plays': plays,
    'likes': likes,
    'isLiked': isLiked,
    'isFavorite': isFavorite,
    'genre': genre,
  };

  MusicTrackModel copyWith({
    String? id,
    String? title,
    String? artist,
    String? albumCover,
    String? audioUrl,
    int? duration,
    int? plays,
    int? likes,
    bool? isLiked,
    bool? isFavorite,
    String? genre,
  }) {
    return MusicTrackModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      albumCover: albumCover ?? this.albumCover,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      plays: plays ?? this.plays,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      isFavorite: isFavorite ?? this.isFavorite,
      genre: genre ?? this.genre,
    );
  }
}
