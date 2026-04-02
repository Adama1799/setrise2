// lib/domain/usecases/music/like_track_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class LikeTrackUsecase {
  final MusicRepository repository;

  LikeTrackUsecase(this.repository);

  Future<Either<Failure, MusicTrackEntity>> call(String trackId) async {
    return repository.likeTrack(trackId);
  }
}
