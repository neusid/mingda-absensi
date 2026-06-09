import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';

void initHistoryAttendanceInjection(GetIt sl) {
  // bloc
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
}
