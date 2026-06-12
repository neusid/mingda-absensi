import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_history_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_attendance_summary_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:mingda_app/features/dashboard/domain/usecases/signout_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final SignoutUsecase signoutUsecase;
  final GetProfileUsecase getprofileUsecase;
  final GetAttendanceSummaryUsecase getattendanceSummaryUsecase;
  final GetAttendanceHistoryUsecase getAttendanceHistoryUsecase;

  DashboardBloc({
    required this.signoutUsecase,
    required this.getprofileUsecase,
    required this.getattendanceSummaryUsecase,
    required this.getAttendanceHistoryUsecase,
  }) : super(InitialDashboardState()) {
    on<DashboardStarted>((event, emit) async {
      // TODO: implement event handler
      emit(LoadingDashboardState());
      final result = await getprofileUsecase();
      await result.fold(
        (l) async {
          if (l.message == "Unauthenticated.") {
            final result = await signoutUsecase();
            result.fold(
              (l) => emit(FailureDashboardState()),
              (r) => emit(SignoutDashboardState()),
            );
          } else {
            emit(FailureGetProfileDashboardState());
          }
        },
        (r1) async {
          final attendance = await getattendanceSummaryUsecase();
          await attendance.fold(
            (l) async {
              emit(FailureGetAttendanceSummaryDashboardState());
            },
            (r2) async {
              final attendanceHistory = await getAttendanceHistoryUsecase();
              await attendanceHistory.fold(
                (l3) async => emit(FailureGetAttendanceHistoryDashboardState()),
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
  }
}
