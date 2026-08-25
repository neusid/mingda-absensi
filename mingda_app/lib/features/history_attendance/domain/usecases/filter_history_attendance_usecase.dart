import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/history_attendance/domain/repositories/history_attendance_repository.dart';

class FilterHistoryAttendanceUsecase {
  final HistoryAttendanceRepository historyAttendanceRepository;
  FilterHistoryAttendanceUsecase({required this.historyAttendanceRepository});

  Future<Either<Failure, AttendanceHistoryEntity>> call(
    int page,
    int? month,
    int? year,
    String? status,
  ) async {
    return await historyAttendanceRepository.filterHistoryAttendanceRepository(
      page,
      month,
      year,
      status,
    );
  }
}
