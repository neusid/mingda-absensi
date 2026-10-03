import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';

class FakeAuthBloc extends Bloc<AuthEvent, AuthState> implements AuthBloc {
  FakeAuthBloc() : super(AuthInitial());

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _buildTestableLoginPage({
  required AuthBloc bloc,
  AppLanguage language = AppLanguage.en,
}) {
  return ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, _) => MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: bloc),
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc(initialLanguage: language),
        ),
      ],
      child: const MaterialApp(
        home: LoginPage(),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthBloc fakeAuthBloc;

  setUp(() {
    fakeAuthBloc = FakeAuthBloc();
  });

  tearDown(() {
    fakeAuthBloc.close();
  });

  testWidgets('LoginPage renders Abstract Teal Gradient and UI elements',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildTestableLoginPage(bloc: fakeAuthBloc));
    await tester.pumpAndSettle();

    // Verify brand pill in abstract teal header
    expect(find.text('MINGDA ATTENDANCE SYSTEM'), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_rounded), findsOneWidget);

    // Verify Welcome text and form fields
    expect(find.text('Welcome Back, 👋'), findsOneWidget);
    expect(find.text('E-Mail'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Remember me'), findsOneWidget);
    expect(find.text('Forgot Password'), findsOneWidget);

    // Verify gradient Sign In button
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Sign In With Google'), findsOneWidget);

    // Verify CustomPaint for abstract vector curves
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('Tapping Forgot Password button navigates to /forgot-password route',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    String? navigatedRoute;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        builder: (context, _) => MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: fakeAuthBloc,
            child: const LoginPage(),
          ),
          onGenerateRoute: (settings) {
            navigatedRoute = settings.name;
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Forgot Password Page Dummy')),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final forgotPasswordFinder = find.byKey(const Key('forgot_password_button'));
    expect(forgotPasswordFinder, findsOneWidget);

    await tester.tap(forgotPasswordFinder);
    await tester.pumpAndSettle();

    expect(navigatedRoute, equals('/forgot-password'));
  });
}
