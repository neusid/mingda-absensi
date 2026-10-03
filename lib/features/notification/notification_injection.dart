import 'package:get_it/get_it.dart';
import 'package:mingda_app/app/config/dio_client.dart';
import 'package:mingda_app/features/notification/data/datasources/notification_dummy_data_source_impl.dart';
import 'package:mingda_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:mingda_app/features/notification/data/datasources/notification_remote_data_source_impl.dart';
import 'package:mingda_app/features/notification/data/repositories/notification_repository_impl.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:mingda_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_bloc.dart';

void initNotificationInjection(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(dio: sl<DioClient>().dio),
    instanceName: 'notification_remote',
  );

  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationDummyDataSourceImpl(),
    instanceName: 'notification_dummy',
  );

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl<NotificationRemoteDataSource>(instanceName: 'notification_remote'),
      dummyDataSource: sl<NotificationRemoteDataSource>(instanceName: 'notification_dummy'),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(
    () => GetNotificationsUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => MarkNotificationAsReadUseCase(repository: sl()),
  );
  sl.registerLazySingleton(
    () => MarkAllNotificationsAsReadUseCase(repository: sl()),
  );

  // BLoC
  sl.registerFactory(
    () => NotificationBloc(
      getNotificationsUseCase: sl(),
      markNotificationAsReadUseCase: sl(),
      markAllNotificationsAsReadUseCase: sl(),
    ),
  );
}
