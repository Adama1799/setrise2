// lib/domain/usecases/music/search_tracks_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class SearchTracksUsecase {
  final MusicRepository repository;

  SearchTracksUsecase(this.repository);

  Future<Either<Failure, List<MusicTrackEntity>>> call(String query) async {
    return repository.searchTracks(query);
  }
}
