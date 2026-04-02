// lib/domain/usecases/music/get_favorite_tracks_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class GetFavoriteTracksUsecase {
  final MusicRepository repository;

  GetFavoriteTracksUsecase(this.repository);

  Future<Either<Failure, List<MusicTrackEntity>>> call() async {
    return repository.getFavoriteTracks();
  }
}
