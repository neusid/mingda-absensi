part of 'history_attendance_bloc.dart';

abstract class HistoryAttendanceEvent extends Equatable {
  const HistoryAttendanceEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class HistoryAttendanceEventStarted extends HistoryAttendanceEvent {
  final AttendanceHistoryEntity historyEntity;
  final AttendanceSummaryEntity summaryEntity;
  const HistoryAttendanceEventStarted({
    required this.historyEntity,
    required this.summaryEntity,
  });
}

class HistoryAttendanceEventFiltered extends HistoryAttendanceEvent {
  final AttendanceHistoryEntity historyEntity;
  final AttendanceSummaryEntity summaryEntity;
  final int page;
  final int? month;
  final int? year;
  final dynamic status;

  const HistoryAttendanceEventFiltered({
    required this.historyEntity,
    required this.summaryEntity,
    required this.page,
    required this.month,
    required this.year,
    required this.status,
  });

  @override
  List<Object?> get props => [
        historyEntity,
        summaryEntity,
        page,
        month,
        year,
        status,
      ];
}

