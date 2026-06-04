import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:mingda_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mingda_app/features/auth/domain/usecases/get_remember_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/remove_auth_session_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/save_remember_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/savetoken_usecase.dart';
import 'package:mingda_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';

void initAuthInjection(GetIt sl) {
  sl.registerLazySingleton<SigninUsecase>(() => SigninUsecase(sl()));

  sl.registerLazySingleton<SavetokenUsecase>(
    () => SavetokenUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<GetRememberUsecase>(
    () => GetRememberUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SaveRememberUsecase>(
    () => SaveRememberUsecase(authRepository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RemoveAuthSessionUsecase>(
    () => RemoveAuthSessionUsecase(authRepository: sl<AuthRepository>()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
      dio: sl<Dio>(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      signinUsecase: sl<SigninUsecase>(),
      getRememberUsecase: sl<GetRememberUsecase>(),
      saveRememberUsecase: sl<SaveRememberUsecase>(),
      removeAuthSessionUsecase: sl<RemoveAuthSessionUsecase>(),
      savetokenUsecase: sl<SavetokenUsecase>(),
    ),
  );
}
