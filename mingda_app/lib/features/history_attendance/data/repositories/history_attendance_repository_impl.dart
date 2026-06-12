import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_remote_data_source.dart';
import 'package:mingda_app/features/history_attendance/domain/repositories/history_attendance_repository.dart';

class HistoryAttendanceRepositoryImpl implements HistoryAttendanceRepository {
  final HistoryAttendanceRemoteDataSource historyAttendanceRemoteDataSource;
  HistoryAttendanceRepositoryImpl({
    required this.historyAttendanceRemoteDataSource,
  });

  Future<Either<Failure, AttendanceHistoryEntity>>
  filterHistoryAttendanceRepository(
    int page,
    int month,
    int year,
    String status,
  ) async {
    try {
      final result = await historyAttendanceRemoteDataSource
          .filterHistoryAttendanceDatasource(page, month, year, status);
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
