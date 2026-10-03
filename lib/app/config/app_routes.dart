import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/routes/mingda_page_route.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/pages/forgot_password_page.dart';
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
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/change_password_page.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/edit_information_page.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_bloc.dart';
import 'package:mingda_app/features/notification/presentation/blocs/notification_event.dart';
import 'package:mingda_app/features/notification/presentation/pages/notification_page.dart';

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
      case '/forgot-password':
        return MingdaPageRoute(
          settings: settings,
          child: const ForgotPasswordPage(),
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
      case '/edit-information':
        final args = settings.arguments as Map<String, dynamic>?;
        final profile = args?['profile'] as ProfileEntity?;
        final bloc = args?['bloc'] as DashboardBloc?;
        if (profile == null) {
          return MingdaPageRoute(
            settings: settings,
            child: const Scaffold(
              body: Center(child: Text('Data profil tidak ditemukan')),
            ),
          );
        }
        return MingdaPageRoute(
          settings: settings,
          child: bloc != null
              ? BlocProvider.value(
                  value: bloc,
                  child: EditInformationPage(profile: profile),
                )
              : EditInformationPage(profile: profile),
        );
      case '/change-password':
        final bloc = settings.arguments as DashboardBloc?;
        return MingdaPageRoute(
          settings: settings,
          child: bloc != null
              ? BlocProvider.value(
                  value: bloc,
                  child: const ChangePasswordPage(),
                )
              : const ChangePasswordPage(),
        );
      case '/notifications':
        return MingdaPageRoute(
          settings: settings,
          child: BlocProvider(
            create: (context) =>
                sl<NotificationBloc>()..add(const FetchNotificationsEvent()),
            child: const NotificationPage(),
          ),
        );
      default:
        return MingdaPageRoute(
          settings: settings,
          child: const LoginPage(),
        );
    }
  }
}
