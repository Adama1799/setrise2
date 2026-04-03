// lib/data/repositories/users_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/users_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/remote/users_remote_datasource.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> getUser(String userId) async {
    try {
      final user = await remoteDataSource.getUser(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> data) async {
    try {
      final user = await remoteDataSource.updateProfile(data);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> followUser(String userId) async {
    try {
      final user = await remoteDataSource.followUser(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> unfollowUser(String userId) async {
    try {
      final user = await remoteDataSource.unfollowUser(userId);
      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query) async {
    try {
      final users = await remoteDataSource.searchUsers(query);
      return Right(users);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUserFollowers(String userId) async {
    try {
      final followers = await remoteDataSource.getUserFollowers(userId);
      return Right(followers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUserFollowing(String userId) async {
    try {
      final following = await remoteDataSource.getUserFollowing(userId);
      return Right(following);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
