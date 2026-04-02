// lib/domain/usecases/music/get_trending_tracks_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class GetTrendingTracksUsecase {
  final MusicRepository repository;

  GetTrendingTracksUsecase(this.repository);

  Future<Either<Failure, List<MusicTrackEntity>>> call() async {
    return repository.getTrendingTracks();
  }
}
