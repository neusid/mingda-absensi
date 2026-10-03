import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationsEvent extends NotificationEvent {
  final bool isRefresh;

  const FetchNotificationsEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String id;

  const MarkNotificationAsReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotificationsAsReadEvent extends NotificationEvent {
  const MarkAllNotificationsAsReadEvent();
}
