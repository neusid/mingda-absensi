import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetAttendanceSummaryUsecase {
  final DashboardRepository dashboardRepository;
  GetAttendanceSummaryUsecase({required this.dashboardRepository});

  Future<Either<Failure, AttendanceSummaryEntity>> call() async {
    return await dashboardRepository.getDataAttendanceSummary();
  }
}
