import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase {
  final NotificationRepository repository;

  GetNotificationsUseCase({required this.repository});

  Future<Either<Failure, List<NotificationEntity>>> call() async {
    return await repository.getNotifications();
  }
}
