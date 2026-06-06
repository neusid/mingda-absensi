import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetAttendanceHistoryUsecase {
  final DashboardRepository dashboardRepository;
  GetAttendanceHistoryUsecase({required this.dashboardRepository});

  Future<Either<Failure, AttendanceHistoryEntity>> call() async {
    return await dashboardRepository.getDataAttendanceHistory();
  }
}
