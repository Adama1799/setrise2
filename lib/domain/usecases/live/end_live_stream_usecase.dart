// lib/domain/usecases/live/end_live_stream_usecase.dart
import 'package:dartz/dartz.dart';
import '../../repositories/live_repository.dart';
import '../../../core/errors/failures.dart';

class EndLiveStreamUsecase {
  final LiveRepository repository;

  EndLiveStreamUsecase(this.repository);

  Future<Either<Failure, void>> call(String streamId) async {
    return repository.endLiveStream(streamId);
  }
}
