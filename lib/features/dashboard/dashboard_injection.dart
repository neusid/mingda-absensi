import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/local_cache_service.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_dummy_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_remote_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/change_password_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_summary_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initDashboardInjection(GetIt sl) {
  // bloc
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(
      signoutUsecase: sl<SignoutUsecase>(),
      getprofileUsecase: sl<GetProfileUsecase>(),
      getattendanceSummaryUsecase: sl<GetAttendanceSummaryUsecase>(),
      getAttendanceHistoryUsecase: sl<GetAttendanceHistoryUsecase>(),
      updateProfileUsecase: sl<UpdateProfileUsecase>(),
      changePasswordUsecase: sl<ChangePasswordUsecase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<SignoutUsecase>(
    () => SignoutUsecase(dashboardRepository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetProfileUsecase>(
    () => GetProfileUsecase(dashboardRepository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<UpdateProfileUsecase>(
    () => UpdateProfileUsecase(dashboardRepository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<ChangePasswordUsecase>(
    () => ChangePasswordUsecase(dashboardRepository: sl<DashboardRepository>()),
  );
  sl.registerLazySingleton<GetAttendanceSummaryUsecase>(
    () => GetAttendanceSummaryUsecase(
      dashboardRepository: sl<DashboardRepository>(),
    ),
  );
  sl.registerLazySingleton<GetAttendanceHistoryUsecase>(
    () => GetAttendanceHistoryUsecase(
      dashboardRepository: sl<DashboardRepository>(),
    ),
  );

  // repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      dashboardLocalDataSource: sl<DashboardLocalDataSource>(),
      dashboardRemoteDataSource: sl<DashboardRemoteDataSource>(),
      dio: sl<DioClient>().dio,
      localCacheService: sl.isRegistered<LocalCacheService>()
          ? sl<LocalCacheService>()
          : null,
      networkInfo:
          sl.isRegistered<NetworkInfo>() ? sl<NetworkInfo>() : null,
    ),
  );

  // data source
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );

  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => AppConfig.isOfflineMode
        ? DashboardDummyDataSourceImpl()
        : DashboardRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
}
