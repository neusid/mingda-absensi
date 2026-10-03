import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/change_password_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_summary_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/update_profile_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SignoutUsecase signoutUsecase;
  final GetProfileUsecase getprofileUsecase;
  final GetAttendanceSummaryUsecase getattendanceSummaryUsecase;
  final GetAttendanceHistoryUsecase getAttendanceHistoryUsecase;
  final UpdateProfileUsecase? updateProfileUsecase;
  final ChangePasswordUsecase? changePasswordUsecase;

  DashboardBloc({
    required this.signoutUsecase,
    required this.getprofileUsecase,
    required this.getattendanceSummaryUsecase,
    required this.getAttendanceHistoryUsecase,
    this.updateProfileUsecase,
    this.changePasswordUsecase,
  }) : super(InitialDashboardState()) {
    on<DashboardStarted>((event, emit) async {
      // TODO: implement event handler
      emit(LoadingDashboardState());
      final result = await getprofileUsecase();
      await result.fold(
        (l) async {
          if (l.message.contains("Unauthenticated") ||
              l.message.contains("401") ||
              l is AuthFailure) {
            final result = await signoutUsecase();
            result.fold(
              (l) => emit(FailureDashboardState()),
              (r) => emit(SignoutDashboardState()),
            );
          } else {
            emit(FailureGetProfileDashboardState(l.message));
          }
        },
        (r1) async {
          final attendance = await getattendanceSummaryUsecase();
          await attendance.fold(
            (l) async {
              if (l is AuthFailure ||
                  l.message.contains("Unauthenticated") ||
                  l.message.contains("401")) {
                await signoutUsecase();
                emit(SignoutDashboardState());
              } else {
                emit(FailureGetAttendanceSummaryDashboardState(l.message));
              }
            },
            (r2) async {
              final attendanceHistory = await getAttendanceHistoryUsecase();
              await attendanceHistory.fold(
                (l3) async {
                  if (l3 is AuthFailure ||
                      l3.message.contains("Unauthenticated") ||
                      l3.message.contains("401")) {
                    await signoutUsecase();
                    emit(SignoutDashboardState());
                  } else {
                    emit(FailureGetAttendanceHistoryDashboardState(l3.message));
                  }
                },
                (r3) async => emit(
                  SuccessDashboardState(
                    profileEntity: r1,
                    attendanceSummaryEntity: r2,
                    attendanceHistoryEntity: r3,
                  ),
                ),
              );
            },
          );
        },
      );
    });

    on<DashboardSignout>((event, emit) async {
      emit(LoadingDashboardState());
      final result = await signoutUsecase();
      result.fold(
        (l) => emit(FailureDashboardState()),
        (r) => emit(SignoutDashboardState()),
      );
    });

    on<DashboardUpdateProfile>((event, emit) async {
      if (updateProfileUsecase == null) {
        event.onError?.call('UpdateProfileUsecase belum terpasang.');
        return;
      }
      final result = await updateProfileUsecase!(event.profile);
      result.fold(
        (failure) {
          event.onError?.call(failure.message);
        },
        (updatedProfile) {
          final current = state;
          if (current is SuccessDashboardState) {
            emit(
              SuccessDashboardState(
                profileEntity: updatedProfile,
                attendanceSummaryEntity: current.attendanceSummaryEntity,
                attendanceHistoryEntity: current.attendanceHistoryEntity,
              ),
            );
          }
          event.onSuccess?.call(updatedProfile);
        },
      );
    });

    on<DashboardChangePassword>((event, emit) async {
      if (changePasswordUsecase == null) {
        event.onError?.call('ChangePasswordUsecase belum terpasang.');
        return;
      }
      final result = await changePasswordUsecase!(
        ChangePasswordParams(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
          confirmPassword: event.confirmPassword,
        ),
      );
      result.fold(
        (failure) {
          event.onError?.call(failure.message);
        },
        (_) {
          event.onSuccess?.call();
        },
      );
    });
  }
}
