import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/network/bloc/network_cubit.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/local_cache_service.dart';
import 'package:mingda_app/core/storage/sync_manager.dart';
import 'package:mingda_app/features/auth/auth_injection.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/dashboard_injection.dart';
import 'package:mingda_app/features/history_attendance/history_attendance_injection.dart';
import 'package:mingda_app/features/notification/notification_injection.dart';
import 'package:mingda_app/features/splash/splash_injection.dart';
import 'package:mingda_app/features/work_leave/work_leave_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Hive Local Storage & Cache
  try {
    await Hive.initFlutter();
  } catch (_) {
    // Handled safely for test runners or multi-init
  }

  final localCacheService = LocalCacheServiceImpl();
  await localCacheService.init();
  sl.registerSingleton<LocalCacheService>(localCacheService);

  final syncManager = SyncManagerImpl();
  await syncManager.init();
  sl.registerSingleton<SyncManager>(syncManager);

  // Network & Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection.createInstance(
        customCheckOptions: [
          InternetCheckOption(
            uri: Uri.parse('https://1.1.1.1'),
            timeout: const Duration(seconds: 3),
          ),
          InternetCheckOption(
            uri: Uri.parse('https://8.8.8.8'),
            timeout: const Duration(seconds: 3),
          ),
        ],
      ));
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl<Connectivity>(),
      internetConnection: sl<InternetConnection>(),
    ),
  );

  sl.registerLazySingleton<NetworkCubit>(
    () => NetworkCubit(
      networkInfo: sl<NetworkInfo>(),
      syncManager: sl<SyncManager>(),
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton(
    () => DioClient(
      dio: sl<Dio>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  // Core Localization
  sl.registerLazySingleton<LanguageBloc>(
    () => LanguageBloc(sharedPreferences: sl<SharedPreferences>()),
  );

  initSplashInjection(sl);
  initAuthInjection(sl);
  initDashboardInjection(sl);
  initHistoryAttendanceInjection(sl);
  initWorkLeaveInjection(sl);
  initNotificationInjection(sl);
}
