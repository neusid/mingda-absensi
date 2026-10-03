import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_event.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;
  final MarkAllNotificationsAsReadUseCase markAllNotificationsAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
    required this.markAllNotificationsAsReadUseCase,
  }) : super(NotificationInitialState()) {
    on<FetchNotificationsEvent>(_onFetchNotifications);
    on<MarkNotificationAsReadEvent>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsReadEvent>(_onMarkAllNotificationsAsRead);
  }

  Future<void> _onFetchNotifications(
    FetchNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (!event.isRefresh) {
      emit(NotificationLoadingState());
    }

    final result = await getNotificationsUseCase();
    result.fold(
      (failure) => emit(NotificationErrorState(message: failure.message)),
      (notifications) => emit(NotificationLoadedState(notifications: notifications)),
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoadedState) {
      final currentList = (state as NotificationLoadedState).notifications;
      final updatedList = currentList.map((n) {
        if (n.id == event.id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      emit(NotificationLoadedState(notifications: updatedList));
      await markNotificationAsReadUseCase(event.id);
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoadedState) {
      final currentList = (state as NotificationLoadedState).notifications;
      final updatedList = currentList.map((n) => n.copyWith(isRead: true)).toList();

      emit(NotificationLoadedState(notifications: updatedList));
      await markAllNotificationsAsReadUseCase();
    }
  }
}
