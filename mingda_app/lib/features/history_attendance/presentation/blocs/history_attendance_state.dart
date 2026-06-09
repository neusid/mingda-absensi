part of 'history_attendance_bloc.dart';

abstract class HistoryAttendanceState extends Equatable {
  const HistoryAttendanceState();
  @override
  List<Object> get props => [];
}

final class HistoryAttendanceInitialState extends HistoryAttendanceState {}

final class HistoryAttendanceLoadingState extends HistoryAttendanceState {}

final class HistoryAttendanceSuccessState extends HistoryAttendanceState {
  final AttendanceHistoryEntity historyEntity;
  final AttendanceSummaryEntity summaryEntity;
  const HistoryAttendanceSuccessState(this.historyEntity, this.summaryEntity);
}

final class HistoryAttendanceFailedState extends HistoryAttendanceState {}
