part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialDashboardState extends DashboardState {}

class LoadingDashboardState extends DashboardState {}

class SuccessDashboardState extends DashboardState {
  final ProfileEntity profileEntity;
  final AttendanceSummaryEntity attendanceSummaryEntity;
  final AttendanceHistoryEntity attendanceHistoryEntity;

  SuccessDashboardState({
    required this.profileEntity,
    required this.attendanceSummaryEntity,
    required this.attendanceHistoryEntity,
  });
}

class SignoutDashboardState extends DashboardState {}

class FailureDashboardState extends DashboardState {}

class FailureGetProfileDashboardState extends DashboardState {}

class FailureGetAttendanceSummaryDashboardState extends DashboardState {}

class FailureGetAttendanceHistoryDashboardState extends DashboardState {}
