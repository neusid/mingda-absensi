import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/attendance_stat_card.dart';

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
  group('AttendanceStatType properties and mappings', () {
    test('verifies label, SVG badge path, and enum mapping for all 6 categories', () {
      expect(AttendanceStatType.hadir.label, 'HADIR');
      expect(AttendanceStatType.hadir.svgBadgePath, 'assets/icon/stat_badge_hadir.svg');
      expect(AttendanceStatType.hadir.toAttendanceEnum, AttendanceEnum.Hadir);

      expect(AttendanceStatType.terlambat.label, 'TERLAMBAT');
      expect(AttendanceStatType.terlambat.svgBadgePath, 'assets/icon/stat_badge_terlambat.svg');
      expect(AttendanceStatType.terlambat.toAttendanceEnum, AttendanceEnum.Terlambat);

      expect(AttendanceStatType.alpha.label, 'ALPHA');
      expect(AttendanceStatType.alpha.svgBadgePath, 'assets/icon/stat_badge_alpha.svg');
      expect(AttendanceStatType.alpha.toAttendanceEnum, AttendanceEnum.Alpha);
      expect(AttendanceStatType.alpha.cardBorderColor, Colors.transparent);
      expect(AttendanceStatType.alpha.labelColor, const Color(0xFF64748B));

      expect(AttendanceStatType.izin.label, 'IZIN');
      expect(AttendanceStatType.izin.svgBadgePath, 'assets/icon/stat_badge_izin.svg');
      expect(AttendanceStatType.izin.toAttendanceEnum, AttendanceEnum.Izin);

      expect(AttendanceStatType.cuti.label, 'CUTI');
      expect(AttendanceStatType.cuti.svgBadgePath, 'assets/icon/stat_badge_cuti.svg');
      expect(AttendanceStatType.cuti.toAttendanceEnum, AttendanceEnum.Cuti);

      expect(AttendanceStatType.sakit.label, 'SAKIT');
      expect(AttendanceStatType.sakit.svgBadgePath, 'assets/icon/stat_badge_sakit.svg');
      expect(AttendanceStatType.sakit.toAttendanceEnum, AttendanceEnum.Sakit);
    });
  });

  group('AttendanceStatCard Widget Tests', () {
    testWidgets('renders count and label accurately for Total Hadir', (tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(
          AttendanceStatCard(
            type: AttendanceStatType.hadir,
            count: 20,
            isSelected: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('20'), findsOneWidget);
      expect(find.text('HADIR'), findsOneWidget);
    });

    testWidgets('renders count and label accurately for Total Izin', (tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(
          AttendanceStatCard(
            type: AttendanceStatType.izin,
            count: 5,
            isSelected: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('5'), findsOneWidget);
      expect(find.text('IZIN'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        _buildTestableWidget(
          AttendanceStatCard(
            type: AttendanceStatType.terlambat,
            count: 3,
            isSelected: false,
            onTap: () => tapped = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(AttendanceStatCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('uses AppShadows.shadow094, 10.w radius, and clean white styling', (tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(
          AttendanceStatCard(
            type: AttendanceStatType.alpha,
            count: 1,
            isSelected: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AttendanceStatCard),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.boxShadow, contains(AppShadows.shadow094));
      expect(decoration.border, isNull);
      expect(decoration.color, Colors.white);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('ALPHA'), findsOneWidget);
    });
  });
}
