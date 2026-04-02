// lib/domain/usecases/live/start_live_stream_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/live_stream_entity.dart';
import '../../repositories/live_repository.dart';
import '../../../core/errors/failures.dart';

class StartLiveStreamUsecase {
  final LiveRepository repository;

  StartLiveStreamUsecase(this.repository);

  Future<Either<Failure, LiveStreamEntity>> call(
    String title,
    String description,
  ) async {
    return repository.startLiveStream(title, description);
  }
}
