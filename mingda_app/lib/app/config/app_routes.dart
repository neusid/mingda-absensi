import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/detail_attendance/presentation/pages/detail_attendance_page.dart';
import 'package:mingda_app/features/root/presentation/pages/root_page.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:mingda_app/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<SplashBloc>(),
            child: SplashPage(),
          ),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<AuthBloc>()..add(AuthStarted()),
            child: LoginPage(),
          ),
        );
      case '/root':
        return MaterialPageRoute(builder: (context) => RootPage());
      case '/detail-attendance':
        final args = settings.arguments as Map<String, dynamic>;

        final profile = args['profile'] as ProfileEntity;
        final attendance = args['attendance'] as AttendanceItemEntity;

        return MaterialPageRoute(
          builder: (context) => DetailAttendancePage(
            profileEntity: profile,
            attendanceItemEntity: attendance,
          ),
        );
      // case '/dashboard':
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider(
      //       create: (context) => sl<DashboardBloc>()..add(DashboardStarted()),
      //       child: DashboardPage(),
      //     ),
      //   );
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
