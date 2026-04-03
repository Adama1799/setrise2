// lib/data/repositories/live_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/live_repository.dart';
import '../../domain/entities/live_stream_entity.dart';
import '../datasources/remote/live_remote_datasource.dart';

class LiveRepositoryImpl implements LiveRepository {
  final LiveRemoteDataSource remoteDataSource;

  LiveRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreams() async {
    try {
      final streams = await remoteDataSource.getLiveStreams();
      return Right(streams);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> getLiveStream(String streamId) async {
    try {
      final stream = await remoteDataSource.getLiveStream(streamId);
      return Right(stream);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> startLiveStream(
    String title,
    String description,
  ) async {
    try {
      final stream = await remoteDataSource.startLiveStream(title, description);
      return Right(stream);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> endLiveStream(String streamId) async {
    try {
      await remoteDataSource.endLiveStream(streamId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> likeLiveStream(String streamId) async {
    try {
      final stream = await remoteDataSource.likeLiveStream(streamId);
      return Right(stream);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, LiveStreamEntity>> unlikeLiveStream(String streamId) async {
    try {
      final stream = await remoteDataSource.unlikeLiveStream(streamId);
      return Right(stream);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> followLiveHost(String hostId) async {
    try {
      await remoteDataSource.followLiveHost(hostId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
