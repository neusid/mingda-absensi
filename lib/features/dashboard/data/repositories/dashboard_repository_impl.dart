import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio dio;
  final DashboardLocalDataSource dashboardLocalDataSource;
  final DashboardRemoteDataSource dashboardRemoteDataSource;
  DashboardRepositoryImpl({
    required this.dio,
    required this.dashboardLocalDataSource,
    required this.dashboardRemoteDataSource,
  });

  Future<Either<Failure, void>> signOut() async {
    try {
      if (!AppConfig.isOfflineMode) {
        try {
          await dio.post('/auth/logout');
        } catch (e) {
          debugPrint('Remote logout warning (safe to ignore): $e');
        }
      }
      await dashboardLocalDataSource.deleteToken();
      await dashboardLocalDataSource.deleteUser();
      return right(null);
    } catch (e) {
      try {
        await dashboardLocalDataSource.deleteToken();
        await dashboardLocalDataSource.deleteUser();
      } catch (_) {}
      return right(null);
    }
  }

  Future<Either<Failure, ProfileEntity>> getDataProfile() async {
    try {
      final result = await dashboardRemoteDataSource.getProfile();
      return right(result);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AttendanceSummaryEntity>>
  getDataAttendanceSummary() async {
    try {
      final result = await dashboardRemoteDataSource.getAttendanceSummary();
      return right(result);
    } on Failure catch (f) {
      debugPrint('getDataAttendanceSummary Failure: $f');
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e, st) {
      debugPrint('getDataAttendanceSummary Error: $e\n$st');
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AttendanceHistoryEntity>>
  getDataAttendanceHistory() async {
    try {
      final result = await dashboardRemoteDataSource.getAttendanceHistory();
      return right(result);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
