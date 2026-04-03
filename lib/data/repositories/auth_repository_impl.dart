// lib/data/repositories/auth_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/errors/exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../datasources/local/preferences_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final PreferencesDataSource preferencesDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.preferencesDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      await preferencesDataSource.saveString('auth_token', response.token);
      return Right(UserModel(
        id: response.userId,
        name: '',
        username: response.username,
        email: response.email,
        avatar: response.avatar,
        bio: '',
        coverImage: '',
        followers: 0,
        following: 0,
        postsCount: 0,
        isFollowing: false,
        isVerified: false,
        createdAt: DateTime.now(),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register(
    String name,
    String email,
    String password,
    String username,
  ) async {
    try {
      final response = await remoteDataSource.register(name, email, password, username);
      await preferencesDataSource.saveString('auth_token', response.token);
      return Right(UserModel(
        id: response.userId,
        name: name,
        username: response.username,
        email: response.email,
        avatar: response.avatar,
        bio: '',
        coverImage: '',
        followers: 0,
        following: 0,
        postsCount: 0,
        isFollowing: false,
        isVerified: false,
        createdAt: DateTime.now(),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await preferencesDataSource.remove('auth_token');
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword) async {
    try {
      await remoteDataSource.changePassword(oldPassword, newPassword);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
