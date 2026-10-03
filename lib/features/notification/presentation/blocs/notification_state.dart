import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final List<NotificationEntity> notifications;

  const NotificationLoadedState({required this.notifications});

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationEntity> get allNotifications => notifications;

  List<NotificationEntity> get announcementNotifications => notifications
      .where((n) => n.category == NotificationCategory.announcement)
      .toList();

  List<NotificationEntity> get activityNotifications => notifications
      .where((n) => n.category == NotificationCategory.activity)
      .toList();

  @override
  List<Object?> get props => [notifications];
}

class NotificationErrorState extends NotificationState {
  final String message;

  const NotificationErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
