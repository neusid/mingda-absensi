import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, ProfileEntity>> getDataProfile();
  Future<Either<Failure, AttendanceSummaryEntity>> getDataAttendanceSummary();
  Future<Either<Failure, AttendanceHistoryEntity>> getDataAttendanceHistory();
}
