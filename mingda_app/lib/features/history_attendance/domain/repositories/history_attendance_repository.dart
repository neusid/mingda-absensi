import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';

abstract class HistoryAttendanceRepository {
  Future<Either<Failure, AttendanceHistoryEntity>>
  filterHistoryAttendanceRepository(
    int page,
    int month,
    int year,
    String status,
  );
}
