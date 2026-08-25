part of 'history_attendance_bloc.dart';

abstract class HistoryAttendanceState extends Equatable {
  const HistoryAttendanceState();
  @override
  List<Object> get props => [];
}

final class HistoryAttendanceInitialState extends HistoryAttendanceState {}

final class HistoryAttendanceEarlyLoadingState extends HistoryAttendanceState {}

final class HistoryAttendanceFilterLoadingState
    extends HistoryAttendanceState {}

abstract class HistoryAttendanceLoadedState extends HistoryAttendanceState {
  final AttendanceHistoryEntity historyEntity;
  final AttendanceSummaryEntity summaryEntity;
  const HistoryAttendanceLoadedState(this.historyEntity, this.summaryEntity);
}

final class HistoryAttendanceEarlyLoadedState
    extends HistoryAttendanceLoadedState {
  const HistoryAttendanceEarlyLoadedState(
    super.historyEntity,
    super.summaryEntity,
  );
}

final class HistoryAttendanceFilterLoadedState
    extends HistoryAttendanceLoadedState {
  AttendanceEnum? attendanceSelected;
  MonthEnum? monthSelected;
  int yearsSelected;
  HistoryAttendanceFilterLoadedState(
    super.historyEntity,
    super.summaryEntity,
    this.attendanceSelected,
    this.monthSelected,
    this.yearsSelected,
  );
}

final class HistoryAttendanceFailedFilterState
    extends HistoryAttendanceLoadedState {
  const HistoryAttendanceFailedFilterState(
    super.historyEntity,
    super.summaryEntity,
  );
}

final class HistoryAttendanceFailedState extends HistoryAttendanceState {}
