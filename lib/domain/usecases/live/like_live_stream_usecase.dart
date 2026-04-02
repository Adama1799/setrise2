// lib/domain/usecases/live/like_live_stream_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/live_stream_entity.dart';
import '../../repositories/live_repository.dart';
import '../../../core/errors/failures.dart';

class LikeLiveStreamUsecase {
  final LiveRepository repository;

  LikeLiveStreamUsecase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call(String streamId) async {
    return repository.likeLiveStream(streamId);
  }
}
