import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/routes/mingda_page_route.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/detail_attendance/presentation/pages/detail_attendance_page.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';
import 'package:mingda_app/features/history_attendance/presentation/pages/history_attendance_page.dart';
import 'package:mingda_app/features/root/presentation/pages/root_page.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:mingda_app/features/splash/presentation/pages/splash_page.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/add_work_leave_page.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/work_leave_page.dart';
import 'package:mingda_app/features/warning_letter/presentation/pages/warning_letter_page.dart';

class AppRoutes {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MingdaPageRoute(
          settings: settings,
          child: BlocProvider(
            create: (context) => sl<SplashBloc>(),
            child: SplashPage(),
          ),
        );
      case '/login':
        return MingdaPageRoute(
          settings: settings,
          child: BlocProvider(
            create: (context) => sl<AuthBloc>()..add(AuthStarted()),
            child: const LoginPage(),
          ),
        );
      case '/root':
        return MingdaPageRoute(
          settings: settings,
          child: const RootPage(),
        );
      case '/detail-attendance':
        final args = settings.arguments as Map<String, dynamic>;

        final profile = args['profile'] as ProfileEntity;
        final attendance = args['attendance'] as AttendanceItemEntity;

        return MingdaPageRoute(
          settings: settings,
          child: DetailAttendancePage(
            profileEntity: profile,
            attendanceItemEntity: attendance,
          ),
        );
      case '/history-attendance':
        final args = settings.arguments as Map<String, dynamic>;

        final summaryAttendance =
            args['summary_attendance'] as AttendanceSummaryEntity;
        final historyAttendance =
            args['history_attendance'] as AttendanceHistoryEntity;
        final profile = args['profile'] as ProfileEntity?;

        return MingdaPageRoute(
          settings: settings,
          child: BlocProvider(
            create: (context) => sl<HistoryAttendanceBloc>()
              ..add(
                HistoryAttendanceEventStarted(
                  historyEntity: historyAttendance,
                  summaryEntity: summaryAttendance,
                ),
              ),
            child: HistoryAttendancePage(profileEntity: profile),
          ),
        );
      case '/work-leave':
        return MingdaPageRoute(
          settings: settings,
          child: const WorkLeavePage(),
        );
      case '/add-work-leave':
        final workLeaveBloc = settings.arguments as WorkLeaveBloc?;
        return MingdaPageRoute(
          settings: settings,
          child: workLeaveBloc != null
              ? BlocProvider.value(
                  value: workLeaveBloc,
                  child: const AddWorkLeavePage(),
                )
              : BlocProvider(
                  create: (context) => sl<WorkLeaveBloc>(),
                  child: const AddWorkLeavePage(),
                ),
        );
      case '/warning-letter':
        return MingdaPageRoute(
          settings: settings,
          child: const WarningLetterPage(),
        );
      default:
        return MingdaPageRoute(
          settings: settings,
          child: const LoginPage(),
        );
    }
  }
}
