// lib/domain/usecases/music/get_track_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class GetTrackUsecase {
  final MusicRepository repository;

  GetTrackUsecase(this.repository);

  Future<Either<Failure, MusicTrackEntity>> call(String trackId) async {
    return repository.getTrack(trackId);
  }
}
