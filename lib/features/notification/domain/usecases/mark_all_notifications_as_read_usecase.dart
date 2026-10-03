import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase({required this.repository});

  Future<Either<Failure, void>> call() async {
    return await repository.markAllAsRead();
  }
}
