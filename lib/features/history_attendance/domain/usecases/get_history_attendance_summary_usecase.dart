import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/history_attendance/domain/repositories/history_attendance_repository.dart';

class GetHistoryAttendanceSummaryUsecase {
  final HistoryAttendanceRepository historyAttendanceRepository;
  GetHistoryAttendanceSummaryUsecase({
    required this.historyAttendanceRepository,
  });

  Future<Either<Failure, AttendanceSummaryEntity>> call(
    int? month,
    int? year,
  ) async {
    return await historyAttendanceRepository.getAttendanceSummaryRepository(
      month,
      year,
    );
  }
}
