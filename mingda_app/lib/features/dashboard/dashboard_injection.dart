import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:mingda_app/features/dashboard/data/datasources/dashboard_local_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void initDashboardInjection(GetIt sl) {
  // bloc
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(signoutUsecase: sl<SignoutUsecase>()),
  );

  // usecase
  sl.registerLazySingleton<SignoutUsecase>(
    () => SignoutUsecase(dashboardRepository: sl<DashboardRepository>()),
  );

  // repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      dashboardLocalDataSource: sl<DashboardLocalDataSource>(),
      dio: sl<DioClient>().dio,
    ),
  );

  // data source
  sl.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSourceImpl(
      sharedPreferences: sl<SharedPreferences>(),
    ),
  );
}
