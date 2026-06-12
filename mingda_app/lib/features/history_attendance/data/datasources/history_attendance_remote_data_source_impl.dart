import 'package:dio/dio.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_remote_data_source.dart';

class HistoryAttendanceRemoteDataSourceImpl
    implements HistoryAttendanceRemoteDataSource {
  final Dio dio;
  HistoryAttendanceRemoteDataSourceImpl({required this.dio});

  Future<AttendanceHistoryModel> filterHistoryAttendanceDatasource(
    int page,
    int month,
    int year,
    String status,
  ) async {
    try {
      final response = await dio.get(
        '/mobile/v1/attendance/history',
        queryParameters: {
          'page': page,
          'month': month,
          'year': year,
          'status': status,
        },
      );

      return AttendanceHistoryModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final apiMessage = e.response?.data['message']?.toString();

      print(
        "DioException getHistoryAttendanceFiltered StatusCode: $statusCode",
      );

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Token sudah tidak berlaku, mohon login ulang',
        );
      }

      if (statusCode == 405) {
        print(apiMessage.toString());
        throw AuthFailure(apiMessage.toString());
      }

      throw ServerFailure(apiMessage ?? 'Server error: $statusCode');
    }
  }
}
