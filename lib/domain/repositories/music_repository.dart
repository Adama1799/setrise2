// lib/domain/repositories/music_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/music_track_entity.dart';
import '../../core/errors/failures.dart';

abstract class MusicRepository {
  Future<Either<Failure, List<MusicTrackEntity>>> getTracks(int page);
  Future<Either<Failure, List<MusicTrackEntity>>> getTrendingTracks();
  Future<Either<Failure, MusicTrackEntity>> getTrack(String trackId);
  Future<Either<Failure, List<MusicTrackEntity>>> searchTracks(String query);
  Future<Either<Failure, List<MusicTrackEntity>>> getPlaylist(String playlistId);
  Future<Either<Failure, MusicTrackEntity>> likeTrack(String trackId);
  Future<Either<Failure, MusicTrackEntity>> unlikeTrack(String trackId);
  Future<Either<Failure, List<MusicTrackEntity>>> getFavoriteTracks();
}
