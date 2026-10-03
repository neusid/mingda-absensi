import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mingda_app/app/config/app_routes.dart';
import 'package:mingda_app/app/config/global_bloc_observer.dart';
import 'package:mingda_app/core/di/injection_container.dart' as di;
import 'package:mingda_app/core/routes/mingda_page_route.dart';
import 'package:mingda_app/core/theme/app_colors.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/localization/bloc/language_event.dart';
import 'package:mingda_app/core/localization/bloc/language_state.dart';
import 'package:mingda_app/core/network/bloc/network_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await initializeDateFormatting('id_ID', null);
  await initializeDateFormatting('en_US', null);
  await initializeDateFormatting('zh_CN', null);
  Bloc.observer = GlobalBlocObserver();

  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final AppRoutes _appRoutes = AppRoutes();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.sl<LanguageBloc>()..add(const LoadLanguageEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<NetworkCubit>(),
        ),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            builder: (context, child) {
              return MaterialApp(
                locale: languageState.language.locale,
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
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: MingdaFadePageTransitionsBuilder(),
                TargetPlatform.iOS: MingdaFadePageTransitionsBuilder(),
              },
            ),
          ),
          onGenerateRoute: _appRoutes.onRoute,
          initialRoute: '/',
        );
      },
    );
        },
      ),
    );
  }
}
