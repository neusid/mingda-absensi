import 'package:dio/dio.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';

class DioClient {
  final Dio dio;
  final AuthLocalDataSource authLocalDataSource;

  DioClient({required this.dio, required this.authLocalDataSource}) {
    dio.options.baseUrl = "https://absensi.mingda.my.id/api";
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = await authLocalDataSource.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          print("Bearer $token");
          options.headers['Accept'] = 'application/json';
          return handler.next(options);
        },
      ),
    );

    // dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
