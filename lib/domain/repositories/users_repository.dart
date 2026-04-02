// lib/domain/repositories/users_repository.dart
import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

abstract class UsersRepository {
  Future<Either<Failure, UserEntity>> getUser(String userId);
  Future<Either<Failure, UserEntity>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, UserEntity>> followUser(String userId);
  Future<Either<Failure, UserEntity>> unfollowUser(String userId);
  Future<Either<Failure, List<UserEntity>>> searchUsers(String query);
  Future<Either<Failure, List<UserEntity>>> getUserFollowers(String userId);
  Future<Either<Failure, List<UserEntity>>> getUserFollowing(String userId);
}
