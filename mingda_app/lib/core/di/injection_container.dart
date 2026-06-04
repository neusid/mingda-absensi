import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/features/auth/auth_injection.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/dashboard_injection.dart';
import 'package:mingda_app/features/splash/splash_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton(
    () => DioClient(
      dio: sl<Dio>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  initSplashInjection(sl);
  initAuthInjection(sl);
  initDashboardInjection(sl);
}
