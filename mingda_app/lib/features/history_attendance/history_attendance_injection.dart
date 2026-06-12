<<<<<<< HEAD
import 'package:get_it/get_it.dart';
=======
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_remote_data_source.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_remote_data_source_impl.dart';
import 'package:mingda_app/features/history_attendance/data/repositories/history_attendance_repository_impl.dart';
import 'package:mingda_app/features/history_attendance/domain/repositories/history_attendance_repository.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/filter_history_attendance_usecase.dart';
>>>>>>> features/dashboard
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';

void initHistoryAttendanceInjection(GetIt sl) {
  // bloc
<<<<<<< HEAD
  sl.registerFactory<HistoryAttendanceBloc>(() => HistoryAttendanceBloc());

  // usecase
  // sl.registerLazySingleton<GettokenUsecase>(
  //   () => GettokenUsecase(splashRepository: sl<SplashRepository>()),
  // );

  // repository
  // sl.registerLazySingleton<SplashRepository>(
  //   () => SplashRepositoryImpl(
  //     splashRemoteDataSource: sl<SplashRemoteDataSource>(),
  //     splashLocalDataSource: sl<SplashLocalDataSource>(),
  //   ),
  // );

  // data source
  // sl.registerLazySingleton<SplashRemoteDataSource>(
  //   () => SplashRemoteDataSourceImpl(),
  // );
  // sl.registerLazySingleton<SplashLocalDataSource>(
  //   () => SplashLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  // );
=======
  sl.registerFactory<HistoryAttendanceBloc>(
    () => HistoryAttendanceBloc(
      filterHistoryAttendanceUsecase: sl<FilterHistoryAttendanceUsecase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<FilterHistoryAttendanceUsecase>(
    () => FilterHistoryAttendanceUsecase(
      historyAttendanceRepository: sl<HistoryAttendanceRepository>(),
    ),
  );

  // repository
  sl.registerLazySingleton<HistoryAttendanceRepository>(
    () => HistoryAttendanceRepositoryImpl(
      historyAttendanceRemoteDataSource:
          sl<HistoryAttendanceRemoteDataSource>(),
    ),
  );

  // data source
  sl.registerLazySingleton<HistoryAttendanceRemoteDataSource>(
    () => HistoryAttendanceRemoteDataSourceImpl(dio: sl<Dio>()),
  );
>>>>>>> features/dashboard
}
