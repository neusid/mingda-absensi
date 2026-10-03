import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mingda_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mingda_app/features/auth/presentation/pages/forgot_password_page.dart';

class MockAuthRepositoryForForgot implements AuthRepository {
  String? lastEmail;
  Failure? failureToReturn;
  String successMessage = 'Tautan pemulihan kata sandi telah dikirim ke email Anda.';

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) async {
    lastEmail = email;
    if (failureToReturn != null) {
      return Left(failureToReturn!);
    }
    return Right(successMessage);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _buildTestableForgotPasswordPage({
  required ForgotPasswordUseCase useCase,
}) {
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
          secondary: AppColors.filterGradientEnd,
        ),
      ),
      home: ForgotPasswordPage(forgotPasswordUseCase: useCase),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepositoryForForgot mockRepo;
  late ForgotPasswordUseCase forgotPasswordUseCase;

  setUp(() {
    mockRepo = MockAuthRepositoryForForgot();
    forgotPasswordUseCase = ForgotPasswordUseCase(authRepository: mockRepo);
  });

  group('ForgotPasswordPage UI & Clean Architecture Tests', () {
    testWidgets('Renders all Mingda Abstract Teal Gradient design elements',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableForgotPasswordPage(useCase: forgotPasswordUseCase),
      );
      await tester.pumpAndSettle();

      // Brand pill
      expect(find.text('MINGDA ATTENDANCE SYSTEM'), findsOneWidget);
      expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);

      // Back button & Lock Reset Badge
      expect(find.byKey(const Key('forgot_password_back_button')), findsOneWidget);
      expect(find.byIcon(Icons.lock_reset_rounded), findsOneWidget);

      // Header texts
      expect(find.text('Lupa Kata Sandi?'), findsOneWidget);
      expect(find.text('Email Perusahaan'), findsOneWidget);

      // Form field & advisory notice
      expect(find.byKey(const Key('forgot_password_email_input')), findsOneWidget);
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

      // Submit Button
      expect(find.byKey(const Key('submit_forgot_password_button')), findsOneWidget);
      expect(find.text('Kirim Tautan Pemulihan'), findsOneWidget);

      // Back link
      expect(find.byKey(const Key('back_to_login_button')), findsOneWidget);
    });

    testWidgets('Validates email field when empty or invalid', (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableForgotPasswordPage(useCase: forgotPasswordUseCase),
      );
      await tester.pumpAndSettle();

      // Submit empty
      await tester.tap(find.byKey(const Key('submit_forgot_password_button')));
      await tester.pumpAndSettle();

      expect(find.text('Alamat email wajib diisi'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(
        find.byKey(const Key('forgot_password_email_input')),
        'invalidemail',
      );
      await tester.tap(find.byKey(const Key('submit_forgot_password_button')));
      await tester.pumpAndSettle();

      expect(find.text('Format email tidak valid'), findsOneWidget);
    });

    testWidgets('Submits successfully and renders Success Confirmation View',
        (tester) async {
      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableForgotPasswordPage(useCase: forgotPasswordUseCase),
      );
      await tester.pumpAndSettle();

      // Enter valid email
      await tester.enterText(
        find.byKey(const Key('forgot_password_email_input')),
        'karyawan@mingda.co.id',
      );

      // Submit
      await tester.tap(find.byKey(const Key('submit_forgot_password_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Verify UseCase called with correct email
      expect(mockRepo.lastEmail, equals('karyawan@mingda.co.id'));

      // Verify Success View
      expect(find.text('Email Terkirim!'), findsOneWidget);
      expect(find.byKey(const Key('success_target_email_text')), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byKey(const Key('success_back_to_login_button')), findsOneWidget);
      expect(find.byKey(const Key('resend_email_button')), findsOneWidget);
    });

    testWidgets('Handles error message when repository returns failure',
        (tester) async {
      mockRepo.failureToReturn = const ServerFailure(
        'Email tidak terdaftar dalam sistem Mingda.',
      );

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableForgotPasswordPage(useCase: forgotPasswordUseCase),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('forgot_password_email_input')),
        'unknown@mingda.co.id',
      );

      await tester.tap(find.byKey(const Key('submit_forgot_password_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // SnackBar with error message
      expect(
        find.text('Email tidak terdaftar dalam sistem Mingda.'),
        findsOneWidget,
      );
    });
  });
}
