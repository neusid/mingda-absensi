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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  await initializeDateFormatting('id_ID', null);
  Bloc.observer = GlobalBlocObserver();

  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final AppRoutes _appRoutes = AppRoutes();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.bg,
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
  }
}
