import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';
import 'package:mingda_app/features/dashboard/data/models/profile_model.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  static const baseURL = "https://absensi.mingda.my.id/api";
  final Dio dio;
  DashboardRemoteDataSourceImpl({required this.dio});

  Future<void> SignOutDataSource(String token) async {
    final response = await http.post(
      Uri.parse('${baseURL}/auth/logout'),
      headers: {'X-Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == '401') {
      throw AuthFailure(body['message']);
    }

    throw ServerFailure(
      body['message'] ?? 'Server error: ${response.statusCode}',
    );
  }

  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get('/mobile/v1/profile');
      print(response.data);
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      final apiMessage = e.response?.data['message']?.toString();

      print("DioException getProfile StatusCode: $statusCode");
      print(apiMessage);

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Token tidak dikenali, mohon login ulang',
        );
      }

      if (statusCode == 405) {
        print(apiMessage.toString());
        throw AuthFailure(apiMessage.toString());
      }

      throw ServerFailure(apiMessage ?? 'Server error: $statusCode');
    }
  }

  Future<AttendanceSummaryModel> getAttendanceSummary() async {
    try {
      final response = await dio.get('/mobile/v1/attendance/summary');
      print(response.data);
      return AttendanceSummaryModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      final apiMessage = e.response?.data['message']?.toString();

      print("DioException getProfile StatusCode: $statusCode");

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

  Future<AttendanceHistoryModel> getAttendanceHistory() async {
    try {
      final response = await dio.get('/mobile/v1/attendance/history');
      print(response.data);
      return AttendanceHistoryModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      final apiMessage = e.response?.data['message']?.toString();

      print("DioException getProfile StatusCode: $statusCode");

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
