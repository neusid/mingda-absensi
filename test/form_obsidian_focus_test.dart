import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/auth/presentation/widgets/InputAuth.dart';

Widget _buildTestableInputAuth({
  required TextEditingController controller,
  bool isPassword = false,
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
          surface: Colors.white,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.filterTealAccent,
          selectionColor: AppColors.mingdaInputSelection,
          selectionHandleColor: AppColors.filterTealAccent,
        ),
        focusColor: AppColors.filterTealAccent,
        inputDecorationTheme: InputDecorationTheme(
          focusColor: AppColors.filterTealAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(
              width: 1.6,
              color: AppColors.filterTealAccent,
            ),
          ),
        ),
      ),
      home: Scaffold(
        body: Center(
          child: InputAuth(
            label: 'E-Mail',
            hintText: 'Enter your email',
            controller: controller,
            isPassword: isPassword,
          ),
        ),
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Mingda Form Focus & Theme Tests', () {
    testWidgets('InputAuth applies Mingda Teal theme on focus', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(_buildTestableInputAuth(controller: controller));
      await tester.pumpAndSettle();

      // Find TextField
      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      final TextField initialField = tester.widget<TextField>(textFieldFinder);
      expect(initialField.cursorColor, equals(AppColors.filterTealAccent));

      // Initially not focused: verify refined Slate-200 border and soft background
      final OutlineInputBorder initialBorder =
          initialField.decoration?.enabledBorder as OutlineInputBorder;
      expect(initialBorder.borderSide.color, equals(const Color(0xFFE2E8F0)));
      expect(initialBorder.borderSide.width, equals(1.2));

      Text labelWidget = tester.widget<Text>(find.text('E-Mail'));
      expect(labelWidget.style?.color, equals(const Color(0xFF334155)));

      // Tap to focus on the text field
      await tester.tap(textFieldFinder);
      await tester.pumpAndSettle();

      // Label should transition to Mingda Teal color
      labelWidget = tester.widget<Text>(find.text('E-Mail'));
      expect(labelWidget.style?.color, equals(AppColors.filterTealAccent));
      expect(labelWidget.style?.fontWeight, equals(FontWeight.w600));

      // Focused border in TextField decoration should be Mingda Teal
      final TextField focusedField = tester.widget<TextField>(textFieldFinder);
      final OutlineInputBorder focusedBorder =
          focusedField.decoration?.focusedBorder as OutlineInputBorder;
      expect(focusedBorder.borderSide.color, equals(AppColors.filterTealAccent));

      // AnimatedContainer decoration should have Mingda glow shadow
      final animatedContainerFinder = find.byType(AnimatedContainer);
      expect(animatedContainerFinder, findsOneWidget);
      final AnimatedContainer animatedContainer =
          tester.widget<AnimatedContainer>(animatedContainerFinder);
      final BoxDecoration decoration = animatedContainer.decoration as BoxDecoration;
      final List<BoxShadow>? shadows = decoration.boxShadow;
      expect(shadows, isNotNull);
      expect(shadows!.first.color, equals(AppColors.mingdaInputGlow));
    });

    testWidgets('InputAuth password visibility icon uses Mingda Teal theme on focus',
        (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      tester.view.physicalSize = const Size(393, 852);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        _buildTestableInputAuth(controller: controller, isPassword: true),
      );
      await tester.pumpAndSettle();

      final textFormFieldFinder = find.byType(TextFormField);

      // Focus
      await tester.tap(textFormFieldFinder);
      await tester.pumpAndSettle();

      // Icon should be Mingda Teal colored
      final iconFinder = find.byIcon(Icons.visibility_outlined);
      expect(iconFinder, findsOneWidget);
      final Icon iconWidget = tester.widget<Icon>(iconFinder);
      expect(iconWidget.color, equals(AppColors.filterTealAccent));
    });

    test('AppColors contains defined Mingda Brand Input palette', () {
      expect(AppColors.inputBorderActive, equals(AppColors.filterTealAccent));
      expect(AppColors.mingdaInputFocus, equals(AppColors.filterTealAccent));
      expect(AppColors.mingdaInputGlow, equals(const Color(0xFF0D9488).withValues(alpha: 0.14)));
      expect(AppColors.mingdaInputSelection, equals(const Color(0xFF0D9488).withValues(alpha: 0.22)));
    });
  });
}
