import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/localization/bloc/language_event.dart';
import 'package:mingda_app/core/localization/bloc/language_state.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/language_swap_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initializeDateFormatting('id_ID', null);
    await initializeDateFormatting('en_US', null);
    await initializeDateFormatting('zh_CN', null);
  });

  group('AppLanguage Enum Tests', () {
    test('should resolve correct values for ID, EN, and ZH', () {
      expect(AppLanguage.id.code, 'id');
      expect(AppLanguage.id.shortLabel, 'ID');
      expect(AppLanguage.id.flagEmoji, '🇮🇩');

      expect(AppLanguage.en.code, 'en');
      expect(AppLanguage.en.shortLabel, 'EN');
      expect(AppLanguage.en.flagEmoji, '🇬🇧');

      expect(AppLanguage.zh.code, 'zh');
      expect(AppLanguage.zh.shortLabel, 'ZH');
      expect(AppLanguage.zh.flagEmoji, '🇨🇳');
    });

    test('fromCode should parse valid and fallback codes', () {
      expect(AppLanguage.fromCode('id'), AppLanguage.id);
      expect(AppLanguage.fromCode('en'), AppLanguage.en);
      expect(AppLanguage.fromCode('zh'), AppLanguage.zh);
      expect(AppLanguage.fromCode('unknown'), AppLanguage.id);
      expect(AppLanguage.fromCode(null), AppLanguage.id);
    });
  });

  group('AppTranslations Tests', () {
    test('should provide accurate translations across languages', () {
      final idTr = AppTranslations(AppLanguage.id);
      final enTr = AppTranslations(AppLanguage.en);
      final zhTr = AppTranslations(AppLanguage.zh);

      // Greeting
      expect(idTr.greetingByHour(8), 'Selamat Pagi,');
      expect(enTr.greetingByHour(8), 'Good Morning,');
      expect(zhTr.greetingByHour(8), '早上好，');

      // Shift & Cards
      expect(idTr.statPresent, 'Hadir');
      expect(enTr.statPresent, 'Present');
      expect(zhTr.statPresent, '出勤');

      expect(idTr.thisMonth, 'bulan ini');
      expect(enTr.thisMonth, 'this month');
      expect(zhTr.thisMonth, '本月');

      expect(idTr.leaveBalance, 'Sisa Cuti');
      expect(enTr.leaveBalance, 'Leave Balance');
      expect(zhTr.leaveBalance, '剩余年假');

      // Detail Attendance
      expect(idTr.timeInformation, 'Informasi Waktu');
      expect(enTr.timeInformation, 'Time Information');
      expect(zhTr.timeInformation, '考勤时间明细');

      expect(idTr.gpsInformation, 'Informasi GPS');
      expect(enTr.gpsInformation, 'GPS Information');
      expect(zhTr.gpsInformation, '定位打卡信息');

      // Work Leave
      expect(idTr.leaveApplicationsHistory, 'Riwayat Pengajuan Cuti');
      expect(enTr.leaveApplicationsHistory, 'Leave Application History');
      expect(zhTr.leaveApplicationsHistory, '休假申请记录');

      expect(idTr.createLeaveApplication, 'Buat Pengajuan Baru');
      expect(enTr.createLeaveApplication, 'New Leave Application');
      expect(zhTr.createLeaveApplication, '创建休假申请');

      expect(idTr.leaveStatUsed, 'Cuti Terpakai');
      expect(enTr.leaveStatUsed, 'Leave Used');
      expect(zhTr.leaveStatUsed, '已用假期');

      // Warning Letters
      expect(idTr.spActiveUpper, 'SP AKTIF');
      expect(enTr.spActiveUpper, 'ACTIVE WARNINGS');
      expect(zhTr.spActiveUpper, '生效中警告');

      expect(idTr.totalSpReceivedUpper, 'TOTAL SP DITERIMA');
      expect(enTr.totalSpReceivedUpper, 'TOTAL WARNINGS RECEIVED');
      expect(zhTr.totalSpReceivedUpper, '收到纪律警告总计');

      expect(idTr.downloadPdf, 'Unduh PDF');
      expect(enTr.downloadPdf, 'Download PDF');
      expect(zhTr.downloadPdf, '下载 PDF');
    });

    test('DateFormatter toLocalizedString supports all 3 languages', () {
      final date = DateTime(2026, 10, 3); // Saturday
      expect(date.toLocalizedString(AppLanguage.id), contains('2026'));
      expect(date.toLocalizedString(AppLanguage.en), contains('2026'));
      expect(date.toLocalizedString(AppLanguage.zh), contains('2026年10月3日'));
    });
  });

  group('LanguageBloc Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state defaults to AppLanguage.id', () {
      final bloc = LanguageBloc(sharedPreferences: prefs);
      expect(bloc.state.language, AppLanguage.id);
    });

    test('LoadLanguageEvent should load stored preference', () async {
      await prefs.setString(LanguageBloc.prefKey, 'zh');
      final bloc = LanguageBloc(sharedPreferences: prefs);

      bloc.add(const LoadLanguageEvent());
      await expectLater(
        bloc.stream,
        emits(const LanguageState(language: AppLanguage.zh)),
      );
    });

    test('ChangeLanguageEvent should update state and save to SharedPreferences', () async {
      final bloc = LanguageBloc(sharedPreferences: prefs);

      bloc.add(const ChangeLanguageEvent(AppLanguage.en));
      await expectLater(
        bloc.stream,
        emits(const LanguageState(language: AppLanguage.en)),
      );

      expect(prefs.getString(LanguageBloc.prefKey), 'en');
    });
  });

  group('LanguageSwapButton Widget Tests', () {
    late SharedPreferences prefs;
    late LanguageBloc languageBloc;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      languageBloc = LanguageBloc(sharedPreferences: prefs);
    });

    tearDown(() {
      languageBloc.close();
    });

    Widget createTestableWidget() {
      return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return BlocProvider.value(
            value: languageBloc,
            child: MaterialApp(
              home: Scaffold(
                body: SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: LanguageSwapButton(bloc: languageBloc),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    testWidgets('renders current language ID badge initially', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('🇮🇩'), findsOneWidget);
      expect(find.text('ID'), findsOneWidget);
      expect(find.byType(LanguageSwapButton), findsOneWidget);
    });

    testWidgets('tap opens dropdown and switches language to English', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      // Tap on the button to open popup menu
      await tester.tap(find.byKey(const Key('dashboard_language_swap_button')));
      await tester.pumpAndSettle();

      // Verify all 3 options are shown in popup
      expect(find.text('English'), findsOneWidget);
      expect(find.text('Bahasa Indonesia'), findsOneWidget);
      expect(find.text('简体中文'), findsOneWidget);

      // Select English
      final englishFinder = find.text('English');
      expect(englishFinder, findsOneWidget);
      await tester.tap(englishFinder);
      await tester.pumpAndSettle(); // Closes popup menu and triggers onSelected
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle(); // Rebuilds with new LanguageState

      // State and UI should update to English
      expect(languageBloc.state.language, AppLanguage.en);
      expect(
        find.descendant(
          of: find.byType(LanguageSwapButton),
          matching: find.text('🇬🇧'),
        ),
        findsOneWidget,
      );
      expect(find.text('EN'), findsOneWidget);
      expect(find.text('Language switched to English'), findsOneWidget);
    });

    testWidgets('tap opens dropdown and switches language to Chinese', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestableWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('dashboard_language_swap_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('简体中文'));
      await tester.pumpAndSettle(); // Closes popup menu and triggers onSelected
      await tester.runAsync(() async {
        await Future.delayed(const Duration(milliseconds: 50));
      });
      await tester.pumpAndSettle(); // Rebuilds with new LanguageState

      expect(languageBloc.state.language, AppLanguage.zh);
      expect(
        find.descendant(
          of: find.byType(LanguageSwapButton),
          matching: find.text('🇨🇳'),
        ),
        findsOneWidget,
      );
      expect(find.text('ZH'), findsOneWidget);
      expect(find.text('语言已切换为简体中文'), findsOneWidget);
    });
  });
}
