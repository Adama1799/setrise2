// lib/data/repositories/music_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/music_repository.dart';
import '../../domain/entities/music_track_entity.dart';
import '../datasources/remote/music_remote_datasource.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicRemoteDataSource remoteDataSource;

  MusicRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MusicTrackEntity>>> getTracks(int page) async {
    try {
      final tracks = await remoteDataSource.getTracks(page);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MusicTrackEntity>>> getTrendingTracks() async {
    try {
      final tracks = await remoteDataSource.getTrendingTracks();
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MusicTrackEntity>> getTrack(String trackId) async {
    try {
      final track = await remoteDataSource.getTrack(trackId);
      return Right(track);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MusicTrackEntity>>> searchTracks(String query) async {
    try {
      final tracks = await remoteDataSource.searchTracks(query);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MusicTrackEntity>>> getPlaylist(String playlistId) async {
    try {
      final tracks = await remoteDataSource.getPlaylist(playlistId);
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MusicTrackEntity>> likeTrack(String trackId) async {
    try {
      final track = await remoteDataSource.likeTrack(trackId);
      return Right(track);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MusicTrackEntity>> unlikeTrack(String trackId) async {
    try {
      final track = await remoteDataSource.unlikeTrack(trackId);
      return Right(track);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MusicTrackEntity>>> getFavoriteTracks() async {
    try {
      final tracks = await remoteDataSource.getFavoriteTracks();
      return Right(tracks);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
