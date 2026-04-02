// lib/domain/usecases/live/get_live_stream_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/live_stream_entity.dart';
import '../../repositories/live_repository.dart';
import '../../../core/errors/failures.dart';

class GetLiveStreamUsecase {
  final LiveRepository repository;

  GetLiveStreamUsecase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call(String streamId) async {
    return repository.getLiveStream(streamId);
  }
}
