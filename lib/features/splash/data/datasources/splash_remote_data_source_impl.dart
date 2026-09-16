import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source.dart';

class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
  static const baseURL = "https://absensi.mingda.my.id/api";

  Future<void> CheckToken(String token) async {
    final response = await http
        .get(
          Uri.parse('${baseURL}/mobile/v1/profile'),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(const Duration(seconds: 10));

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 401) {
      throw AuthFailure(body['message']);
    }

    throw ServerFailure(
      body['message'] ?? 'Server error: ${response.statusCode}',
    );
  }
}
