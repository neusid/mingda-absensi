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
      return ProfileModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final apiMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure();
      }

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Token tidak dikenali, mohon login ulang',
        );
      }

      if (statusCode == 405) {
        throw AuthFailure(apiMessage ?? 'Metode tidak didukung');
      }

      throw ServerFailure(
        apiMessage ?? 'Terjadi kendala pada server (Kode: $statusCode)',
      );
    } catch (e) {
      throw ServerFailure('Gagal memproses data profil: $e');
    }
  }

  Future<AttendanceSummaryModel> getAttendanceSummary() async {
    try {
      final response = await dio.get('/mobile/v1/attendance/summary');
      return AttendanceSummaryModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final apiMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure();
      }

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Token sudah tidak berlaku, mohon login ulang',
        );
      }

      if (statusCode == 405) {
        throw AuthFailure(apiMessage ?? 'Metode tidak didukung');
      }

      throw ServerFailure(
        apiMessage ?? 'Terjadi kendala pada server (Kode: $statusCode)',
      );
    } catch (e) {
      throw ServerFailure('Gagal memproses ringkasan absensi: $e');
    }
  }

  Future<AttendanceHistoryModel> getAttendanceHistory() async {
    try {
      final response = await dio.get('/mobile/v1/attendance/history');
      return AttendanceHistoryModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final apiMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const TimeoutFailure();
      }
      if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure();
      }

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Token sudah tidak berlaku, mohon login ulang',
        );
      }

      if (statusCode == 405) {
        throw AuthFailure(apiMessage ?? 'Metode tidak didukung');
      }

      throw ServerFailure(
        apiMessage ?? 'Terjadi kendala pada server (Kode: $statusCode)',
      );
    } catch (e) {
      throw ServerFailure('Gagal memproses riwayat absensi: $e');
    }
  }
}
