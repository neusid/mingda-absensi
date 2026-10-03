import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/models/login_model.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  static const baseURL = "https://absensi.mingda.my.id/api";

  Future<LoginModel> SignInDataSource({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
          'token_name': 'mobile-app',
        },
      );
      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final message = e.message;

      final apiMessage = e.response?.data['message']?.toString();

      print("DioException StatusCode: $statusCode");

      if (statusCode == 401) {
        throw AuthFailure(apiMessage ?? 'Email atau password salah');
      }

      if (statusCode == 422) {
        throw ValidationFailure(apiMessage ?? 'Format email tidak valid');
      }

      throw ServerFailure(apiMessage ?? 'Server error: $statusCode');
    }
  }

  Future<void> SignOutDataSource(String token) async {
    final response = await http.post(
      Uri.parse('${baseURL}/auth/logout'),
      headers: {'X-Authorization': 'Bearer $token'},
    );

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 401) {
      throw AuthFailure(body['message']);
    }

    throw ServerFailure(
      body['message'] ?? 'Server error: ${response.statusCode}',
    );
  }

  Future<void> CheckToken(String token) async {
    final response = await http.post(
      Uri.parse('${baseURL}/mobile/v1/profile'),
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

  @override
  Future<String> forgotPasswordDataSource({required String email}) async {
    try {
      final response = await dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            'Tautan pemulihan kata sandi telah dikirim ke email Anda.';
      }
      return 'Tautan pemulihan kata sandi telah dikirim ke email Anda.';
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      String? apiMessage;

      if (data is Map<String, dynamic>) {
        apiMessage = data['message']?.toString();
        if (statusCode == 422 && data['errors'] is Map) {
          final errors = data['errors'] as Map<String, dynamic>;
          final errList = <String>[];
          errors.forEach((_, v) {
            if (v is List && v.isNotEmpty) {
              errList.add(v.first.toString());
            } else if (v is String) {
              errList.add(v);
            }
          });
          if (errList.isNotEmpty) {
            throw ValidationFailure(errList.join(', '));
          }
        }
      }

      if (statusCode == 404) {
        throw ServerFailure(
          apiMessage ?? 'Email tidak terdaftar dalam sistem Mingda.',
        );
      }

      if (statusCode == 422) {
        throw ValidationFailure(
          apiMessage ?? 'Format email tidak valid.',
        );
      }

      throw ServerFailure(
        apiMessage ?? 'Terjadi kesalahan pada server ($statusCode).',
      );
    }
  }
}
