import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';

abstract class HistoryAttendanceRemoteDataSource {
  Future<AttendanceHistoryModel> filterHistoryAttendanceDatasource(
    int page,
    int month,
    int year,
    String status,
  );
}
