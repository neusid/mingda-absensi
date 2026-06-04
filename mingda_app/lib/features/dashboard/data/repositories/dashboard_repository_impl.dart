import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio dio;
  final DashboardLocalDataSource dashboardLocalDataSource;
  DashboardRepositoryImpl({
    required this.dio,
    required this.dashboardLocalDataSource,
  });

  Future<Either<Failure, void>> signOut() async {
    try {
      await dio.get('/auth/logout');
      await dashboardLocalDataSource.deleteToken();
      await dashboardLocalDataSource.deleteUser();
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
