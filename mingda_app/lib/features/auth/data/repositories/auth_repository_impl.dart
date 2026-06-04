import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/models/auth_session_model.dart';
import 'package:mingda_app/features/auth/data/models/user_model.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final Dio dio;

  const AuthRepositoryImpl({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
    required this.dio,
  });

  Future<Either<Failure, void>> saveRememberRepository(
    AuthSessionEntity entity,
  ) async {
    try {
      await authLocalDataSource.saveRemember(
        AuthSessionModel.fromEntity(entity),
      );

      return right(null);
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool?>> getRememberRepository() async {
    try {
      final result = await authLocalDataSource.getRemember();

      return right(result);
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool?>> removeSessionRepository() async {
    try {
      final result = await authLocalDataSource.getRemember();

      return right(result);
    } on Failure catch (f) {
      return left(f);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, LoginEntity>> SignIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await authRemoteDataSource.SignInDataSource(
        email: email,
        password: password,
      );

      return right(result);
      // Error Failure dari data source
    } on Failure catch (f) {
      print(f);
      return left(f);
      // Error status code blm terbentuk
    } on SocketException {
      print("Network failure");
      return left(NetworkFailure());
    } catch (e) {
      print(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> SignOut({required String token}) async {
    try {
      await authRemoteDataSource.SignOutDataSource(token);
      await authLocalDataSource.deleteUser();
      return right(null);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> SaveToken(String token) async {
    try {
      await authLocalDataSource.saveToken(token);
      return right(null);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> SaveUser(UserModel user) async {
    try {
      await authLocalDataSource.saveUser(user);
      return right(null);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
