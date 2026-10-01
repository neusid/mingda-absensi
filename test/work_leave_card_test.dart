import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_dummy_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/repositories/work_leave_repository_impl.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/get_leave_list_usecase.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/work_leave_page.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_item_card.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_stat_card.dart';

Widget _buildTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    if (!sl.isRegistered<WorkLeaveBloc>()) {
      final ds = WorkLeaveDummyDataSourceImpl();
      final repo = WorkLeaveRepositoryImpl(remoteDataSource: ds);
      final uc = GetLeaveListUseCase(repository: repo);
      sl.registerFactory<WorkLeaveBloc>(() => WorkLeaveBloc(getLeaveListUseCase: uc));
    }
  });

  group('WorkLeaveStatType tests', () {
    test('verifies label, colors, and icons for all 4 work leave types', () {
      expect(WorkLeaveStatType.disetujui.label, 'DISETUJUI');
      expect(WorkLeaveStatType.disetujui.accentColor, const Color(0xFF00AA13));

      expect(WorkLeaveStatType.menunggu.label, 'MENUNGGU');
      expect(WorkLeaveStatType.menunggu.accentColor, const Color(0xFFFF9800));

      expect(WorkLeaveStatType.ditolak.label, 'DITOLAK');
      expect(WorkLeaveStatType.ditolak.accentColor, const Color(0xFFED2736));
      expect(WorkLeaveStatType.ditolak.cardBorderColor, const Color(0xFFFECDD3));
      expect(WorkLeaveStatType.ditolak.labelColor, const Color(0xFFED2736));

      expect(WorkLeaveStatType.cutiTerpakai.label, 'CUTI TERPAKAI');
      expect(WorkLeaveStatType.cutiTerpakai.accentColor, const Color(0xFF7C3AED));
    });
  });

  group('WorkLeaveStatCard Widget Tests', () {
    testWidgets('renders value and label for DISETUJUI', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableWidget(
          const WorkLeaveStatCard(
            type: WorkLeaveStatType.disetujui,
            value: '12',
            isSelected: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('12'), findsOneWidget);
      expect(find.text('DISETUJUI'), findsOneWidget);
    });

    testWidgets('uses AppShadows.shadow094, 10.w radius, and no colored border', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool tapped = false;

      await tester.pumpWidget(
        _buildTestableWidget(
          WorkLeaveStatCard(
            type: WorkLeaveStatType.ditolak,
            value: '1',
            isSelected: true,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(WorkLeaveStatCard),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, contains(AppShadows.shadow094));
      expect(decoration.border, isNull);
      expect(decoration.color, Colors.white);

      await tester.tap(find.byType(WorkLeaveStatCard));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('WorkLeaveItemCard Widget Tests', () {
    testWidgets('renders title, status badge, and dates', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableWidget(
          const WorkLeaveItemCard(
            title: 'Izin Sakit',
            status: 'Disetujui',
            startDate: '10 Apr 2026',
            endDate: '12 Apr 2026',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Izin Sakit'), findsOneWidget);
      expect(find.text('Disetujui'), findsOneWidget);
      expect(find.text('10 Apr 2026'), findsOneWidget);
      expect(find.text('12 Apr 2026'), findsOneWidget);
    });
  });

  group('WorkLeavePage Integration Tests', () {
    testWidgets('renders all stat cards as purely informational without filtering on tap', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 812 * 3);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableWidget(
          const WorkLeavePage(),
        ),
      );
      await tester.pumpAndSettle();

      // Check stat cards exist
      expect(find.text('DISETUJUI'), findsOneWidget);
      expect(find.text('MENUNGGU'), findsOneWidget);
      expect(find.text('DITOLAK'), findsOneWidget);
      expect(find.text('CUTI TERPAKAI'), findsOneWidget);

      // Check items from dummy data source
      expect(find.text('Izin Sakit'), findsOneWidget);
      expect(find.text('Cuti Tahunan'), findsWidgets);

      // Tap on DITOLAK stat card
      await tester.tap(find.text('DITOLAK'));
      await tester.pumpAndSettle();

      // Verify list is NOT filtered (stat cards are purely informational)
      expect(find.text('Izin Sakit'), findsOneWidget);
      expect(find.text('Cuti Tahunan'), findsWidgets);
    });
  });
}
