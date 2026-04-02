// lib/domain/repositories/live_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/live_stream_entity.dart';
import '../../core/errors/failures.dart';

abstract class LiveRepository {
  Future<Either<Failure, List<LiveStreamEntity>>> getLiveStreams();
  Future<Either<Failure, LiveStreamEntity>> getLiveStream(String streamId);
  Future<Either<Failure, LiveStreamEntity>> startLiveStream(String title, String description);
  Future<Either<Failure, void>> endLiveStream(String streamId);
  Future<Either<Failure, LiveStreamEntity>> likeLiveStream(String streamId);
  Future<Either<Failure, LiveStreamEntity>> unlikeLiveStream(String streamId);
  Future<Either<Failure, void>> followLiveHost(String hostId);
}
