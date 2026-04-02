// lib/domain/usecases/music/get_tracks_usecase.dart
import 'package:dartz/dartz.dart';
import '../../entities/music_track_entity.dart';
import '../../repositories/music_repository.dart';
import '../../../core/errors/failures.dart';

class GetTracksUsecase {
  final MusicRepository repository;

  GetTracksUsecase(this.repository);

  Future<Either<Failure, List<MusicTrackEntity>>> call(int page) async {
    return repository.getTracks(page);
  }
}
