import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/hive_constants.dart';
import 'package:mingda_app/core/storage/local_cache_service.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';
import 'package:mingda_app/features/dashboard/data/models/profile_model.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final Dio dio;
  final DashboardLocalDataSource dashboardLocalDataSource;
  final DashboardRemoteDataSource dashboardRemoteDataSource;
  final LocalCacheService? localCacheService;
  final NetworkInfo? networkInfo;

  DashboardRepositoryImpl({
    required this.dio,
    required this.dashboardLocalDataSource,
    required this.dashboardRemoteDataSource,
    this.localCacheService,
    this.networkInfo,
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
      final isOnline = await networkInfo?.isConnected ?? true;
      if (isOnline) {
        try {
          final result = await dashboardRemoteDataSource.getProfile();
          if (localCacheService != null) {
            await localCacheService!.put(HiveConstants.profileKey, result.toJson());
          }
          return right(result);
        } catch (e) {
          final cached = localCacheService?.getMap(HiveConstants.profileKey);
          if (cached != null) {
            return right(ProfileModel.fromJson(cached));
          }
          rethrow;
        }
      } else {
        final cached = localCacheService?.getMap(HiveConstants.profileKey);
        if (cached != null) {
          return right(ProfileModel.fromJson(cached));
        }
        final result = await dashboardRemoteDataSource.getProfile();
        return right(result);
      }
    } on Failure catch (f) {
      final cached = localCacheService?.getMap(HiveConstants.profileKey);
      if (cached != null) {
        return right(ProfileModel.fromJson(cached));
      }
      return left(f);
    } on SocketException {
      final cached = localCacheService?.getMap(HiveConstants.profileKey);
      if (cached != null) {
        return right(ProfileModel.fromJson(cached));
      }
      return left(NetworkFailure());
    } catch (e) {
      final cached = localCacheService?.getMap(HiveConstants.profileKey);
      if (cached != null) {
        return right(ProfileModel.fromJson(cached));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AttendanceSummaryEntity>>
  getDataAttendanceSummary() async {
    try {
      final isOnline = await networkInfo?.isConnected ?? true;
      if (isOnline) {
        try {
          final result = await dashboardRemoteDataSource.getAttendanceSummary();
          if (localCacheService != null) {
            await localCacheService!.put(
              HiveConstants.attendanceSummaryKey,
              result.toJson(),
            );
          }
          return right(result);
        } catch (e) {
          final cached = localCacheService?.getMap(HiveConstants.attendanceSummaryKey);
          if (cached != null) {
            return right(AttendanceSummaryModel.fromJson(cached));
          }
          rethrow;
        }
      } else {
        final cached = localCacheService?.getMap(HiveConstants.attendanceSummaryKey);
        if (cached != null) {
          return right(AttendanceSummaryModel.fromJson(cached));
        }
        final result = await dashboardRemoteDataSource.getAttendanceSummary();
        return right(result);
      }
    } on Failure catch (f) {
      final cached = localCacheService?.getMap(HiveConstants.attendanceSummaryKey);
      if (cached != null) {
        return right(AttendanceSummaryModel.fromJson(cached));
      }
      debugPrint('getDataAttendanceSummary Failure: $f');
      return left(f);
    } on SocketException {
      final cached = localCacheService?.getMap(HiveConstants.attendanceSummaryKey);
      if (cached != null) {
        return right(AttendanceSummaryModel.fromJson(cached));
      }
      return left(NetworkFailure());
    } catch (e, st) {
      final cached = localCacheService?.getMap(HiveConstants.attendanceSummaryKey);
      if (cached != null) {
        return right(AttendanceSummaryModel.fromJson(cached));
      }
      debugPrint('getDataAttendanceSummary Error: $e\n$st');
      return left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, AttendanceHistoryEntity>>
  getDataAttendanceHistory() async {
    try {
      final isOnline = await networkInfo?.isConnected ?? true;
      if (isOnline) {
        try {
          final result = await dashboardRemoteDataSource.getAttendanceHistory();
          if (localCacheService != null) {
            await localCacheService!.put(
              HiveConstants.attendanceHistoryKey,
              result.toJson(),
            );
          }
          return right(result);
        } catch (e) {
          final cached = localCacheService?.getMap(HiveConstants.attendanceHistoryKey);
          if (cached != null) {
            return right(AttendanceHistoryModel.fromJson(cached));
          }
          rethrow;
        }
      } else {
        final cached = localCacheService?.getMap(HiveConstants.attendanceHistoryKey);
        if (cached != null) {
          return right(AttendanceHistoryModel.fromJson(cached));
        }
        final result = await dashboardRemoteDataSource.getAttendanceHistory();
        return right(result);
      }
    } on Failure catch (f) {
      final cached = localCacheService?.getMap(HiveConstants.attendanceHistoryKey);
      if (cached != null) {
        return right(AttendanceHistoryModel.fromJson(cached));
      }
      return left(f);
    } on SocketException {
      final cached = localCacheService?.getMap(HiveConstants.attendanceHistoryKey);
      if (cached != null) {
        return right(AttendanceHistoryModel.fromJson(cached));
      }
      return left(NetworkFailure());
    } catch (e) {
      final cached = localCacheService?.getMap(HiveConstants.attendanceHistoryKey);
      if (cached != null) {
        return right(AttendanceHistoryModel.fromJson(cached));
      }
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
    ProfileEntity profile,
  ) async {
    try {
      final model = profile is ProfileModel
          ? profile
          : ProfileModel.fromEntity(profile);
      final result = await dashboardRemoteDataSource.updateProfile(model);
      return right(result);
    } on Failure catch (f) {
      return left(f);
    } on SocketException {
      return left(NetworkFailure());
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await dashboardRemoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
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
