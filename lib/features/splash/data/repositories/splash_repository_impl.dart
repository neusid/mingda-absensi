import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';

class SplashRepositoryImpl implements SplashRepository {
  final SplashRemoteDataSource splashRemoteDataSource;
  final SplashLocalDataSource splashLocalDataSource;

  const SplashRepositoryImpl({
    required this.splashRemoteDataSource,
    required this.splashLocalDataSource,
  });

  Future<Either<Failure, String>> GetToken() async {
    try {
      final String? token = await splashLocalDataSource.getToken();
      if (token == null) throw StorageNotFoundFailure('Token tidak tersedia.');
      return right(token);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> CheckToken(String token) async {
    try {
      await splashRemoteDataSource.CheckToken(token);
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
