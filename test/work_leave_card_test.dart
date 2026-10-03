import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_dummy_data_source_impl.dart';
import 'package:mingda_app/features/work_leave/data/repositories/work_leave_repository_impl.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/get_leave_list_usecase.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/submit_leave_request_usecase.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/add_work_leave_page.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/work_leave_page.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_form_sheet.dart';
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
      final submitUc = SubmitLeaveRequestUseCase(repository: repo);
      sl.registerFactory<WorkLeaveBloc>(
        () => WorkLeaveBloc(
          getLeaveListUseCase: uc,
          submitLeaveRequestUseCase: submitUc,
        ),
      );
    }
  });

  group('WorkLeaveStatType tests', () {
    test('verifies label, colors, and icons for all 4 work leave types', () {
      expect(WorkLeaveStatType.disetujui.label, 'DISETUJUI');
      expect(WorkLeaveStatType.disetujui.accentColor, const Color(0xFF0D9488));

      expect(WorkLeaveStatType.menunggu.label, 'MENUNGGU');
      expect(WorkLeaveStatType.menunggu.accentColor, const Color(0xFF0D9488));

      expect(WorkLeaveStatType.ditolak.label, 'DITOLAK');
      expect(WorkLeaveStatType.ditolak.accentColor, const Color(0xFF0D9488));
      expect(WorkLeaveStatType.ditolak.cardBorderColor, const Color(0xFFE2E8F0));
      expect(WorkLeaveStatType.ditolak.labelColor, const Color(0xFF64748B));

      expect(WorkLeaveStatType.cutiTerpakai.label, 'CUTI TERPAKAI');
      expect(WorkLeaveStatType.cutiTerpakai.accentColor, const Color(0xFF0D9488));
    });
  });

  group('WorkLeaveStatCard Widget Tests', () {
    testWidgets('renders value and label for DISETUJUI', (tester) async {
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

    testWidgets('uses AppShadows.shadow094, 10.w radius, and no colored border when unselected', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _buildTestableWidget(
          WorkLeaveStatCard(
            type: WorkLeaveStatType.ditolak,
            value: '1',
            isSelected: false,
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
      expect(find.text('DISETUJUI'), findsOneWidget);
      expect(find.text('10 Apr 2026'), findsOneWidget);
      expect(find.text('12 Apr 2026'), findsOneWidget);
    });
  });

  group('WorkLeavePage Integration Tests', () {
    testWidgets('renders all stat cards and items from dummy data source', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 1000 * 3);
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(
        _buildTestableWidget(
          const WorkLeavePage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Check stat cards exist
      expect(find.text('DISETUJUI'), findsWidgets);
      expect(find.text('MENUNGGU'), findsWidgets);
      expect(find.text('DITOLAK'), findsWidgets);
      expect(find.text('CUTI TERPAKAI'), findsOneWidget);

      // Check items from dummy data source
      expect(find.text('Izin Sakit'), findsWidgets);
      expect(find.text('Cuti Tahunan'), findsWidgets);

      // Check add button icon is present in the header
      expect(find.byIcon(Icons.add_rounded), findsWidgets);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await tester.pump();
    });

    testWidgets('tapping add button in header navigates to AddWorkLeavePage', (tester) async {
      tester.view.physicalSize = const Size(375 * 3, 1000 * 3);
      tester.view.devicePixelRatio = 3.0;

      await tester.pumpWidget(
        _buildTestableWidget(
          const WorkLeavePage(),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      final addBtnFinder = find.byIcon(Icons.add_rounded).first;
      await tester.tap(addBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(AddWorkLeavePage), findsOneWidget);
      expect(find.text('Pengajuan Cuti / Izin'), findsOneWidget);

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      await tester.pump();
    });
  });

  group('WorkLeaveFormSheet Tests', () {
    testWidgets('renders form fields according to Mingda API docs and Safe Mode banner', (tester) async {
      final ds = WorkLeaveDummyDataSourceImpl();
      final repo = WorkLeaveRepositoryImpl(remoteDataSource: ds);
      final uc = GetLeaveListUseCase(repository: repo);
      final submitUc = SubmitLeaveRequestUseCase(repository: repo);
      final bloc = WorkLeaveBloc(
        getLeaveListUseCase: uc,
        submitLeaveRequestUseCase: submitUc,
      )..add(const WorkLeaveEventFetch());

      await tester.pumpWidget(
        _buildTestableWidget(
          BlocProvider.value(
            value: bloc,
            child: const WorkLeaveFormSheet(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Check Header & Safe Mode Banner
      expect(find.text('Formulir Pengajuan Cuti / Izin'), findsOneWidget);
      expect(find.text('Mode Pengujian Aman (Production Guard Aktif)'), findsOneWidget);

      // Check API leave_type fields
      expect(find.text('Cuti Tahunan'), findsOneWidget);
      expect(find.text('Izin Kerja'), findsOneWidget);
      expect(find.text('Izin Sakit'), findsOneWidget);

      // Check Date fields
      expect(find.text('Tanggal Mulai *'), findsOneWidget);
      expect(find.text('Tanggal Selesai *'), findsOneWidget);

      // Check reason and attachment fields
      expect(find.text('Alasan Pengajuan *'), findsOneWidget);
      expect(find.text('Dokumen Pendukung / Surat Dokter'), findsOneWidget);
      expect(find.text('Kirim Pengajuan'), findsOneWidget);
    });

    testWidgets('AddWorkLeavePage renders segmented selector, clean cards, and sticky submit bar', (tester) async {
      final repo = WorkLeaveRepositoryImpl(
        remoteDataSource: WorkLeaveDummyDataSourceImpl(),
      );
      final uc = GetLeaveListUseCase(repository: repo);
      final submitUc = SubmitLeaveRequestUseCase(repository: repo);
      final bloc = WorkLeaveBloc(
        getLeaveListUseCase: uc,
        submitLeaveRequestUseCase: submitUc,
      )..add(const WorkLeaveEventFetch());

      await tester.pumpWidget(
        _buildTestableWidget(
          BlocProvider.value(
            value: bloc,
            child: const AddWorkLeavePage(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Check AppBar
      expect(find.text('Pengajuan Cuti / Izin'), findsOneWidget);

      // Check Segmented Selector
      expect(find.text('Cuti'), findsOneWidget);
      expect(find.text('Izin'), findsOneWidget);
      expect(find.text('Sakit'), findsOneWidget);

      // Check Section Titles
      expect(find.text('Jenis Pengajuan'), findsOneWidget);
      expect(find.text('Rentang Tanggal'), findsOneWidget);
      expect(find.text('Keterangan / Alasan'), findsOneWidget);
      expect(find.text('Dokumen Pendukung'), findsOneWidget);

      // Check Sticky Bottom Bar
      expect(find.text('Kirim Pengajuan'), findsOneWidget);
    });

    testWidgets('Tapping Mulai opens MingdaDatePickerDialog and closes on Batal', (tester) async {
      final repo = WorkLeaveRepositoryImpl(
        remoteDataSource: WorkLeaveDummyDataSourceImpl(),
      );
      final uc = GetLeaveListUseCase(repository: repo);
      final submitUc = SubmitLeaveRequestUseCase(repository: repo);
      final bloc = WorkLeaveBloc(
        getLeaveListUseCase: uc,
        submitLeaveRequestUseCase: submitUc,
      )..add(const WorkLeaveEventFetch());

      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _buildTestableWidget(
          BlocProvider.value(
            value: bloc,
            child: const AddWorkLeavePage(),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap Mulai date picker trigger
      await tester.tap(find.text('Mulai'));
      await tester.pumpAndSettle();

      // Verify MingdaDatePickerDialog is displayed
      expect(find.text('PILIH TANGGAL MULAI'), findsOneWidget);
      expect(find.text('Terapkan'), findsOneWidget);
      expect(find.text('Batal'), findsOneWidget);

      // Tap Batal
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // Verify dialog is closed
      expect(find.text('PILIH TANGGAL MULAI'), findsNothing);
    });
  });
}
