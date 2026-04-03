// lib/data/repositories/dating_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/dating_repository.dart';
import '../../domain/entities/dating_profile_entity.dart';
import '../datasources/remote/dating_remote_datasource.dart';

class DatingRepositoryImpl implements DatingRepository {
  final DatingRemoteDataSource remoteDataSource;

  DatingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DatingProfileEntity>>> getProfiles() async {
    try {
      final profiles = await remoteDataSource.getProfiles();
      return Right(profiles);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DatingProfileEntity>> getProfile(String profileId) async {
    try {
      final profile = await remoteDataSource.getProfile(profileId);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, DatingProfileEntity>> updateProfile(
    Map<String, dynamic> data,
  ) async {
    try {
      final profile = await remoteDataSource.updateProfile(data);
      return Right(profile);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> likeProfile(String profileId) async {
    try {
      await remoteDataSource.likeProfile(profileId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> passProfile(String profileId) async {
    try {
      await remoteDataSource.passProfile(profileId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<DatingProfileEntity>>> getMatches() async {
    try {
      final matches = await remoteDataSource.getMatches();
      return Right(matches);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> startConversation(String profileId) async {
    try {
      await remoteDataSource.startConversation(profileId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
