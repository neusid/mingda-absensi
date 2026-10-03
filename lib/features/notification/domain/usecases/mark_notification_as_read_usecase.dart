import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase({required this.repository});

  Future<Either<Failure, void>> call(String id) async {
    return await repository.markAsRead(id);
  }
}
