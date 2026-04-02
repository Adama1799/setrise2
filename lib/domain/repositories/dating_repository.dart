// lib/domain/repositories/dating_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/dating_profile_entity.dart';
import '../../core/errors/failures.dart';

abstract class DatingRepository {
  Future<Either<Failure, List<DatingProfileEntity>>> getProfiles();
  Future<Either<Failure, DatingProfileEntity>> getProfile(String profileId);
  Future<Either<Failure, DatingProfileEntity>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, void>> likeProfile(String profileId);
  Future<Either<Failure, void>> passProfile(String profileId);
  Future<Either<Failure, List<DatingProfileEntity>>> getMatches();
  Future<Either<Failure, void>> startConversation(String profileId);
}
