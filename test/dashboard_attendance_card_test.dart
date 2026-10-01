import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/dashboard_attendance_card.dart';

Widget _buildTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 375,
            child: child,
          ),
        ),
      ),
    ),
  );
}

void main() {
  const dummyItem = AttendanceItemEntity(
    id: 1,
    employeeId: 1,
    attendanceDate: '2026-05-15',
    checkIn: '10:00',
    checkOut: '17:00',
    status: 'hadir',
    isMockedIn: false,
    isSuspiciousIn: false,
    isMockedOut: false,
    isSuspiciousOut: false,
    lateMinutes: 0,
    overtimeMinutes: 0,
    createdAt: '2026-05-15 10:00:00',
    updatedAt: '2026-05-15 17:00:00',
  );

  const dummyLateItem = AttendanceItemEntity(
    id: 2,
    employeeId: 1,
    attendanceDate: '2026-05-14',
    checkIn: '10:45',
    checkOut: '17:00',
    status: 'terlambat',
    isMockedIn: false,
    isSuspiciousIn: false,
    isMockedOut: false,
    isSuspiciousOut: false,
    lateMinutes: 15,
    overtimeMinutes: 0,
    createdAt: '2026-05-14 10:45:00',
    updatedAt: '2026-05-14 17:00:00',
  );

  group('DashboardAttendanceItem.fromAttendanceList', () {
    test('extracts up to 4 items with Pulang and Masuk events in correct order and marks today', () {
      final items = DashboardAttendanceItem.fromAttendanceList(
        [
          dummyItem,
          dummyLateItem,
        ],
        limit: 4,
        treatLatestAsToday: true,
      );

      expect(items.length, 4);

      // 1. Pulang Mei 15 (Today)
      expect(items[0].type, DashboardAttendanceType.pulang);
      expect(items[0].title, 'Pulang');
      expect(items[0].statusText, 'Tepat Waktu');
      expect(items[0].dateText, 'Mei 15, 2026');
      expect(items[0].timeText, '05:00 pm');
      expect(items[0].method, 'Via Fingerprint');
      expect(items[0].isToday, isTrue);

      // 2. Masuk Mei 15 (Today)
      expect(items[1].type, DashboardAttendanceType.masuk);
      expect(items[1].title, 'Masuk');
      expect(items[1].statusText, 'Tepat Waktu');
      expect(items[1].dateText, 'Mei 15, 2026');
      expect(items[1].timeText, '10:00 am');
      expect(items[1].isLate, isFalse);
      expect(items[1].isToday, isTrue);

      // 3. Pulang Mei 14 (Previous Day)
      expect(items[2].type, DashboardAttendanceType.pulang);
      expect(items[2].title, 'Pulang');
      expect(items[2].statusText, 'Tepat Waktu');
      expect(items[2].dateText, 'Mei 14, 2026');
      expect(items[2].timeText, '05:00 pm');
      expect(items[2].isToday, isFalse);

      // 4. Masuk Mei 14 (Previous Day - Terlambat 15m)
      expect(items[3].type, DashboardAttendanceType.masuk);
      expect(items[3].title, 'Masuk');
      expect(items[3].statusText, 'Terlambat (15m)');
      expect(items[3].dateText, 'Mei 14, 2026');
      expect(items[3].timeText, '10:45 am');
      expect(items[3].isLate, isTrue);
      expect(items[3].lateMinutes, 15);
      expect(items[3].isToday, isFalse);
    });

    test('extracts all items when limit is null for history attendance', () {
      final items = DashboardAttendanceItem.fromAttendanceList([
        dummyItem,
        dummyLateItem,
      ]);

      expect(items.length, 4);
    });

    test('respects treatLatestAsToday = false and keeps past months as white cards', () {
      final items = DashboardAttendanceItem.fromAttendanceList(
        [dummyItem, dummyLateItem],
        treatLatestAsToday: false,
      );

      expect(items.length, 4);
      expect(items.every((it) => it.isToday == false), isTrue);
    });

    test('marks isToday = true automatically when attendanceDate matches DateTime.now()', () {
      final now = DateTime.now();
      final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final todayItem = AttendanceItemEntity(
        id: 99,
        employeeId: 1,
        attendanceDate: todayStr,
        checkIn: '08:00',
        checkOut: null,
        status: 'hadir',
        isMockedIn: false,
        isSuspiciousIn: false,
        isMockedOut: false,
        isSuspiciousOut: false,
        lateMinutes: 0,
        overtimeMinutes: 0,
        createdAt: '$todayStr 08:00:00',
        updatedAt: '$todayStr 08:00:00',
      );

      final items = DashboardAttendanceItem.fromAttendanceList([todayItem]);
      expect(items.length, 1);
      expect(items.first.isToday, isTrue);
      expect(items.first.type, DashboardAttendanceType.masuk);
    });
  });

  group('DashboardAttendanceCard Widget Tests', () {
    testWidgets('renders Today Teal card correctly with white text and gradient', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cardItem = DashboardAttendanceItem(
        type: DashboardAttendanceType.masuk,
        title: 'Masuk',
        statusText: 'Tepat Waktu',
        isLate: false,
        dateText: 'Mei 15, 2026',
        timeText: '10:00 am',
        method: 'Via Fingerprint',
        isToday: true,
        attendance: dummyItem,
      );

      await tester.pumpWidget(
        _buildTestableWidget(
          DashboardAttendanceCard(item: cardItem),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Tepat Waktu'), findsOneWidget);
      expect(find.text('Mei 15, 2026'), findsOneWidget);
      expect(find.text('10:00 am'), findsOneWidget);
      expect(find.text('Via Fingerprint'), findsOneWidget);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DashboardAttendanceCard),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isNotNull);
    });

    testWidgets('renders White Pulang card correctly', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cardItem = DashboardAttendanceItem(
        type: DashboardAttendanceType.pulang,
        title: 'Pulang',
        statusText: 'Tepat Waktu',
        isLate: false,
        dateText: 'Mei 14, 2026',
        timeText: '05:00 pm',
        method: 'Via Fingerprint',
        isToday: false,
        attendance: dummyItem,
      );

      await tester.pumpWidget(
        _buildTestableWidget(
          DashboardAttendanceCard(item: cardItem),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pulang'), findsOneWidget);
      expect(find.text('Tepat Waktu'), findsOneWidget);
      expect(find.text('Mei 14, 2026'), findsOneWidget);
      expect(find.text('05:00 pm'), findsOneWidget);
      expect(find.text('Via Fingerprint'), findsOneWidget);
    });

    testWidgets('renders Masuk Terlambat card correctly', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final cardItem = DashboardAttendanceItem(
        type: DashboardAttendanceType.masuk,
        title: 'Masuk',
        statusText: 'Terlambat (15m)',
        isLate: true,
        lateMinutes: 15,
        dateText: 'Mei 14, 2026',
        timeText: '10:45 am',
        method: 'Via Fingerprint',
        isToday: false,
        attendance: dummyLateItem,
      );

      await tester.pumpWidget(
        _buildTestableWidget(
          DashboardAttendanceCard(item: cardItem),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Masuk'), findsOneWidget);
      expect(find.text('Terlambat (15m)'), findsOneWidget);
      expect(find.text('Mei 14, 2026'), findsOneWidget);
      expect(find.text('10:45 am'), findsOneWidget);
      expect(find.text('Via Fingerprint'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when clicked', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool tapped = false;
      final cardItem = DashboardAttendanceItem(
        type: DashboardAttendanceType.masuk,
        title: 'Masuk',
        statusText: 'Tepat Waktu',
        isLate: false,
        dateText: 'Mei 15, 2026',
        timeText: '10:00 am',
        method: 'Via Fingerprint',
        isToday: true,
        attendance: dummyItem,
      );

      await tester.pumpWidget(
        _buildTestableWidget(
          DashboardAttendanceCard(
            item: cardItem,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DashboardAttendanceCard));
      expect(tapped, isTrue);
    });
  });
}
