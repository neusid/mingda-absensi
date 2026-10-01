import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';

abstract class HistoryAttendanceRemoteDataSource {
  Future<AttendanceHistoryModel> filterHistoryAttendanceDatasource(
    int? page,
    int? month,
    int? year,
    String? status,
  );

  Future<AttendanceHistoryModel> paginationHistoryAttendanceDatasource(
    int? page,
    int? month,
    int? year,
    String? status,
  );

  Future<AttendanceSummaryModel> getAttendanceSummaryDatasource(
    int? month,
    int? year,
  );
}
