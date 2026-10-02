import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/warning_letter/presentation/pages/warning_letter_page.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_card.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_filter_dropdown.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_policy_banner.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_policy_dialog.dart';

Widget _buildTestableWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    builder: (context, _) => MaterialApp(
      home: child,
    ),
  );
}

void main() {
  group('WarningLetterPage Stat Cards (Mingda Style)', () {
    testWidgets('renders all 3 stat cards with proper labels, values, and styling', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Verify labels
      expect(find.text('SP AKTIF'), findsOneWidget);
      expect(find.text('SP SELESAI'), findsOneWidget);
      expect(find.text('TOTAL SP DITERIMA'), findsOneWidget);

      // Verify values
      expect(find.text('1'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);

      // Verify icons
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
      expect(find.byIcon(Icons.assignment_outlined), findsOneWidget);

      // Verify each of the 3 stat cards has white border and shadow094
      for (final label in ['SP AKTIF', 'SP SELESAI', 'TOTAL SP DITERIMA']) {
        final labelFinder = find.text(label);
        final cardContainer = tester.widget<Container>(
          find.ancestor(of: labelFinder, matching: find.byType(Container)).first,
        );
        final dec = cardContainer.decoration as BoxDecoration;
        expect(dec.border, Border.all(color: Colors.white, width: 1.5.w));
        expect(dec.boxShadow, contains(AppShadows.shadow094));
      }

      // Verify stat icons use unified Mingda Corporate Teal
      final icons = tester.widgetList<Icon>(find.byType(Icon));
      final tealIcons = icons.where((ic) => ic.color == const Color(0xFF0D9488)).toList();
      expect(tealIcons.length, greaterThanOrEqualTo(3));
    });
  });

  group('WarningLetterPage Remade Filters & Action Buttons (Lines 56-88)', () {
    testWidgets('renders dropdown filters, Cari and Reset buttons with proper initial state', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Verify both filter dropdowns exist
      expect(find.byType(WarningLetterTypeFilterDropdown), findsOneWidget);
      expect(find.byType(WarningLetterStatusFilterDropdown), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
      expect(find.text('Pilih Status'), findsOneWidget);

      // Verify action buttons exist
      expect(find.text('Cari'), findsOneWidget);
      expect(find.byIcon(Icons.search_rounded), findsOneWidget);
      expect(find.text('Reset'), findsOneWidget);
      expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);

      // Verify initial 4 cards are displayed
      expect(find.text('Keterlambatan'), findsOneWidget);
      expect(find.text('Pelanggaran SOP'), findsOneWidget);
      expect(find.text('Absensi'), findsOneWidget);
      expect(find.text('Disiplin'), findsOneWidget);
    });

    testWidgets('filters SP cards when selecting filter and tapping Cari, then restores on Reset', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Open Type dropdown
      await tester.tap(find.byType(WarningLetterTypeFilterDropdown));
      await tester.pumpAndSettle();

      // Select 'SP 2' from dropdown panel
      await tester.tap(find.text('SP 2').last);
      await tester.pumpAndSettle();

      // Tap 'Cari' button
      await tester.tap(find.text('Cari'));
      await tester.pumpAndSettle();

      // Only SP-2 ('Pelanggaran SOP') should be visible
      expect(find.text('Pelanggaran SOP'), findsOneWidget);
      expect(find.text('Keterlambatan'), findsNothing);
      expect(find.text('Absensi'), findsNothing);
      expect(find.text('Disiplin'), findsNothing);

      // Tap 'Reset' button
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();

      // All 4 cards restored
      expect(find.text('Keterlambatan'), findsOneWidget);
      expect(find.text('Pelanggaran SOP'), findsOneWidget);
      expect(find.text('Absensi'), findsOneWidget);
      expect(find.text('Disiplin'), findsOneWidget);
    });

    testWidgets('shows empty state when no cards match filter', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Select Type 'SP 3'
      await tester.tap(find.byType(WarningLetterTypeFilterDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SP 3').last);
      await tester.pumpAndSettle();

      // Select Status 'Selesai' (SP 3 is Aktif, so none matches)
      await tester.tap(find.byType(WarningLetterStatusFilterDropdown));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Selesai').last);
      await tester.pumpAndSettle();

      // Tap Cari
      await tester.tap(find.text('Cari'));
      await tester.pumpAndSettle();

      // Expect empty state
      expect(find.text('Tidak ada Surat Peringatan'), findsOneWidget);
      expect(find.byIcon(Icons.search_off_rounded), findsOneWidget);
    });
  });

  group('WarningLetterCard (Mingda API Doc & Design Pattern)', () {
    testWidgets('renders card fields (sp_number, dates, download button) and gradient status badge for active SP', (tester) async {
      tester.view.physicalSize = const Size(800, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Verify WarningLetterCard instances exist
      expect(find.byType(WarningLetterCard), findsNWidgets(4));

      // Verify official SP numbers from Mingda API docs are displayed
      expect(find.text('SP/001/HRD/I/2026'), findsOneWidget);
      expect(find.text('SP/002/HRD/IV/2026'), findsOneWidget);
      expect(find.text('SP/003/HRD/II/2026'), findsOneWidget);
      expect(find.text('SP/004/HRD/VI/2026'), findsOneWidget);

      // Verify date ranges (issued_date - valid_until)
      expect(find.text('10 Jan 2026 - 10 Jul 2026'), findsOneWidget);

      // Verify download buttons
      expect(find.text('Unduh PDF'), findsNWidgets(4));

      // Scroll into view and tap 'Unduh PDF' on first card
      await tester.ensureVisible(find.text('Unduh PDF').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Unduh PDF').first);
      await tester.pumpAndSettle();
      expect(find.textContaining('Mengunduh berkas fisik SP/001/HRD/I/2026'), findsOneWidget);
    });
  });

  group('WarningLetterPolicyBanner & PolicyDialog', () {
    testWidgets('renders atmospheric policy banner and opens floating policy dialog on tap', (tester) async {
      tester.view.physicalSize = const Size(800, 2600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_buildTestableWidget(const WarningLetterPage()));
      await tester.pumpAndSettle();

      // Verify policy banner exists
      expect(find.byType(WarningLetterPolicyBanner), findsOneWidget);
      expect(find.text('REGULASI & KEPATUHAN'), findsOneWidget);
      expect(find.text('Pedoman Regulasi Surat Peringatan'), findsOneWidget);
      expect(find.text('Baca SOP Kedisiplinan'), findsOneWidget);

      // Tap policy banner to open floating dialog
      await tester.tap(find.byType(WarningLetterPolicyBanner));
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.byType(WarningLetterPolicyDialog), findsOneWidget);
      expect(find.text('Pedoman Regulasi SP'), findsOneWidget);
      expect(find.text('Tingkatan Surat Peringatan'), findsOneWidget);
      expect(find.text('Masa Berlaku & Pemutihan'), findsOneWidget);
      expect(find.text('Hak Klarifikasi & Konseling HRD'), findsOneWidget);
      expect(find.text('Saya Mengerti'), findsOneWidget);

      // Tap 'Saya Mengerti' to dismiss
      await tester.tap(find.text('Saya Mengerti'));
      await tester.pumpAndSettle();
      expect(find.byType(WarningLetterPolicyDialog), findsNothing);
    });
  });
}
