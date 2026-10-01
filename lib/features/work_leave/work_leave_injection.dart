import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_dummy_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/repositories/work_leave_repository_impl.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/get_leave_list_usecase.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';

void initWorkLeaveInjection(GetIt sl) {
  // bloc
  sl.registerFactory<WorkLeaveBloc>(
    () => WorkLeaveBloc(
      getLeaveListUseCase: sl<GetLeaveListUseCase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GetLeaveListUseCase>(
    () => GetLeaveListUseCase(
      repository: sl<WorkLeaveRepository>(),
    ),
  );

  // repository
  sl.registerLazySingleton<WorkLeaveRepository>(
    () => WorkLeaveRepositoryImpl(
      remoteDataSource: sl<WorkLeaveRemoteDataSource>(),
    ),
  );

  // data source
  sl.registerLazySingleton<WorkLeaveRemoteDataSource>(
    () => (AppConfig.isOfflineMode || AppConfig.isWorkLeaveMockMode)
        ? WorkLeaveDummyDataSourceImpl()
        : WorkLeaveRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
}
