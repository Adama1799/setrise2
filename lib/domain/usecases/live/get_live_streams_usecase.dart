// lib/domain/usecases/live/get_live_streams_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/live_stream_entity.dart';
import '../../repositories/live_repository.dart';
import '../../../core/errors/failures.dart';

class GetLiveStreamsUsecase {
  final LiveRepository repository;

  GetLiveStreamsUsecase(this.repository);

  Future<Either<Failure, List<LiveStreamEntity>>> call() async {
    return repository.getLiveStreams();
  }
}
