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

      print('=== SUCCESS ===');
      print('Status: ${response.statusCode}');
      print('Data: ${response.data}');

      return LoginModel.fromJson(response.data);
    } on DioException catch (e) {
      print('=== DIO ERROR ===');
      print('Type: ${e.type}');
      print('Error object: ${e.error}'); // <-- tambah ini
      print('StackTrace: ${e.stackTrace}'); // <-- tambah ini
      print('Message: ${e.message}');
      print('Status: ${e.response?.statusCode}');

      throw ServerFailure('${e.error}');
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

  // Future<UserModel> checkToken({required String token}) async {
  //   final response = await http.post(Uri.parse('$baseURL/api/'));
  //
  //   final body = jsonDecode(response.body) as Map<String, dynamic>;
  //
  //   if (response.statusCode == 200) {
  //     return UserModel.fromJson(body);
  //   }
  //
  //   throw ServerFailure(
  //     body['message'] ?? 'Server error: ${response.statusCode}',
  //   );
  // }
}
