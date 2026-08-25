import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/auth/domain/usecases/get_remember_usecase.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_local_data_source_impl.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:mingda_app/features/splash/data/datasources/splash_remote_data_source_impl.dart';
import 'package:mingda_app/features/splash/data/repositories/splash_repository_impl.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';
import 'package:mingda_app/features/splash/domain/usecases/checktoken_usecase.dart';
import 'package:mingda_app/features/splash/domain/usecases/gettoken_usecase.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initSplashInjection(GetIt sl) {
  // bloc
  sl.registerFactory<SplashBloc>(
    () => SplashBloc(
      getTokenUsecase: sl<GettokenUsecase>(),
      getRememberUsecase: sl<GetRememberUsecase>(),
      checkTokenUsecase: sl<CheckTokenUsecase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GettokenUsecase>(
    () => GettokenUsecase(splashRepository: sl<SplashRepository>()),
  );
  sl.registerLazySingleton<CheckTokenUsecase>(
    () => CheckTokenUsecase(splashRepository: sl<SplashRepository>()),
  );

  // repository
  sl.registerLazySingleton<SplashRepository>(
    () => SplashRepositoryImpl(
      splashRemoteDataSource: sl<SplashRemoteDataSource>(),
      splashLocalDataSource: sl<SplashLocalDataSource>(),
    ),
  );

  // data source
  sl.registerLazySingleton<SplashRemoteDataSource>(
    () => SplashRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );
}
