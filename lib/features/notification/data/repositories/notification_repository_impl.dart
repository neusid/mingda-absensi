import 'package:dartz/dartz.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationRemoteDataSource dummyDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.dummyDataSource,
  });

  NotificationRemoteDataSource get _activeSource =>
      AppConfig.isOfflineMode ? dummyDataSource : remoteDataSource;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final models = await _activeSource.getNotifications();
      return Right(models.map((m) => m.toDomain()).toList());
    } on Failure catch (e) {
      if (!AppConfig.isOfflineMode) {
        // Fallback to dummy gracefully
        try {
          final dummyModels = await dummyDataSource.getNotifications();
          return Right(dummyModels.map((m) => m.toDomain()).toList());
        } catch (_) {}
      }
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _activeSource.getUnreadCount();
      return Right(count);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _activeSource.markAsRead(id);
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _activeSource.markAllAsRead();
      return const Right(null);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
