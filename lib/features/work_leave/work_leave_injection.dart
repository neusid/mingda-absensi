import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/local_cache_service.dart';
import 'package:mingda_app/core/storage/sync_manager.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_dummy_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/repositories/work_leave_repository_impl.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/get_leave_list_usecase.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/submit_leave_request_usecase.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';

void initWorkLeaveInjection(GetIt sl) {
  // bloc
  sl.registerFactory<WorkLeaveBloc>(
    () => WorkLeaveBloc(
      getLeaveListUseCase: sl<GetLeaveListUseCase>(),
      submitLeaveRequestUseCase: sl<SubmitLeaveRequestUseCase>(),
    ),
  );

  // usecase
  sl.registerLazySingleton<GetLeaveListUseCase>(
    () => GetLeaveListUseCase(
      repository: sl<WorkLeaveRepository>(),
    ),
  );
  sl.registerLazySingleton<SubmitLeaveRequestUseCase>(
    () => SubmitLeaveRequestUseCase(
      repository: sl<WorkLeaveRepository>(),
    ),
  );

  // repository
  sl.registerLazySingleton<WorkLeaveRepository>(
    () => WorkLeaveRepositoryImpl(
      remoteDataSource: sl<WorkLeaveRemoteDataSource>(),
      localCacheService: sl.isRegistered<LocalCacheService>()
          ? sl<LocalCacheService>()
          : null,
      syncManager: sl.isRegistered<SyncManager>() ? sl<SyncManager>() : null,
      networkInfo:
          sl.isRegistered<NetworkInfo>() ? sl<NetworkInfo>() : null,
    ),
  );

  // data source
  sl.registerLazySingleton<WorkLeaveRemoteDataSource>(
    () => (AppConfig.isOfflineMode || AppConfig.isWorkLeaveMockMode)
        ? WorkLeaveDummyDataSourceImpl()
        : WorkLeaveRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  );
}
