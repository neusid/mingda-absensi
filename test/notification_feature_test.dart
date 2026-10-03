import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/notification/data/models/notification_model.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';
import 'package:mingda_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:mingda_app/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_all_notifications_as_read_usecase.dart';
import 'package:mingda_app/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_event.dart';
import 'package:mingda_app/features/notification/presentation/pages/notification_page.dart';
import 'package:mingda_app/features/notification/presentation/widgets/notification_detail_sheet.dart';
import 'package:mingda_app/features/notification/presentation/widgets/notification_item_card.dart';

class MockNotificationRepository implements NotificationRepository {
  List<NotificationEntity> notifications = [
    NotificationEntity(
      id: 'n1',
      title: 'Pengumuman Libur Nasional',
      message: 'Operasional diliburkan besok.',
      category: NotificationCategory.announcement,
      type: NotificationType.announcement,
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: false,
    ),
    NotificationEntity(
      id: 'n2',
      title: 'Pengajuan Cuti Disetujui',
      message: 'Cuti Anda telah disetujui HRD.',
      category: NotificationCategory.activity,
      type: NotificationType.leaveApproval,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      actionUrl: '/work-leave',
    ),
  ];

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    return Right(notifications);
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    return Right(notifications.where((n) => !n.isRead).length);
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    notifications = notifications.map((n) {
      if (n.id == id) return n.copyWith(isRead: true);
      return n;
    }).toList();
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    notifications = notifications.map((n) => n.copyWith(isRead: true)).toList();
    return const Right(null);
  }
}

Widget _buildTestableNotificationPage(NotificationBloc bloc) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.filterTealAccent,
          primary: AppColors.filterTealAccent,
        ),
      ),
      home: BlocProvider.value(
        value: bloc,
        child: const NotificationPage(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await initializeDateFormatting('id_ID', null);
  });

  group('Notification Feature Tests', () {
    test('NotificationModel serializes and deserializes properly', () {
      final json = {
        'id': '101',
        'title': 'Test Title',
        'message': 'Test Content',
        'category': 'announcement',
        'type': 'announcement',
        'created_at': '2026-10-03T10:00:00Z',
        'is_read': false,
      };

      final model = NotificationModel.fromJson(json);
      expect(model.id, equals('101'));
      expect(model.title, equals('Test Title'));
      expect(model.category, equals(NotificationCategory.announcement));
      expect(model.isRead, isFalse);

      final exportedJson = model.toJson();
      expect(exportedJson['id'], equals('101'));
      expect(exportedJson['title'], equals('Test Title'));
    });

    testWidgets('NotificationPage renders tabs, list items, and detail sheet',
        (tester) async {
      final repo = MockNotificationRepository();
      final bloc = NotificationBloc(
        getNotificationsUseCase: GetNotificationsUseCase(repository: repo),
        markNotificationAsReadUseCase:
            MarkNotificationAsReadUseCase(repository: repo),
        markAllNotificationsAsReadUseCase:
            MarkAllNotificationsAsReadUseCase(repository: repo),
      );
      addTearDown(bloc.close);

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bloc.add(const FetchNotificationsEvent());

      await tester.pumpWidget(_buildTestableNotificationPage(bloc));
      await tester.pumpAndSettle();

      // Verify AppBar and TabBar
      expect(find.text('Notifikasi'), findsOneWidget);
      expect(find.text('Semua (2)'), findsOneWidget);
      expect(find.text('Pengumuman (1)'), findsOneWidget);
      expect(find.text('Aktivitas (1)'), findsOneWidget);

      // Verify List Items
      expect(find.byType(NotificationItemCard), findsNWidgets(2));
      expect(find.text('Pengumuman Libur Nasional'), findsOneWidget);
      expect(find.text('Pengajuan Cuti Disetujui'), findsOneWidget);

      // Tap on item to open NotificationDetailSheet
      await tester.tap(find.text('Pengumuman Libur Nasional'));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationDetailSheet), findsOneWidget);
      expect(find.text('PENGUMUMAN RESMI'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NotificationDetailSheet),
          matching: find.text('Operasional diliburkan besok.'),
        ),
        findsOneWidget,
      );
      expect(find.text('Mengerti'), findsOneWidget);

      // Dismiss sheet
      await tester.tap(find.text('Mengerti'));
      await tester.pumpAndSettle();

      expect(find.byType(NotificationDetailSheet), findsNothing);

      // Test Mark All As Read
      expect(find.byKey(const Key('mark_all_read_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('mark_all_read_button')));
      await tester.pumpAndSettle();

      // Snack bar should show
      expect(find.text('Semua notifikasi ditandai telah dibaca'), findsOneWidget);
    });

    testWidgets('NotificationPage switches tabs and displays filtered items',
        (tester) async {
      final repo = MockNotificationRepository();
      final bloc = NotificationBloc(
        getNotificationsUseCase: GetNotificationsUseCase(repository: repo),
        markNotificationAsReadUseCase:
            MarkNotificationAsReadUseCase(repository: repo),
        markAllNotificationsAsReadUseCase:
            MarkAllNotificationsAsReadUseCase(repository: repo),
      );
      addTearDown(bloc.close);

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bloc.add(const FetchNotificationsEvent());

      await tester.pumpWidget(_buildTestableNotificationPage(bloc));
      await tester.pumpAndSettle();

      // Tap on Pengumuman Tab
      await tester.tap(find.text('Pengumuman (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Pengumuman Libur Nasional'), findsOneWidget);

      // Tap on Aktivitas Tab
      await tester.tap(find.text('Aktivitas (1)'));
      await tester.pumpAndSettle();

      expect(find.text('Pengajuan Cuti Disetujui'), findsOneWidget);
    });
  });
}
