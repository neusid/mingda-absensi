part of 'work_leave_bloc.dart';

abstract class WorkLeaveEvent extends Equatable {
  const WorkLeaveEvent();

  @override
  List<Object?> get props => [];
}

class WorkLeaveEventFetch extends WorkLeaveEvent {
  final int? month;
  final int? year;
  final String? status;

  const WorkLeaveEventFetch({
    this.month,
    this.year,
    this.status,
  });

  @override
  List<Object?> get props => [month, year, status];
}

class WorkLeaveEventFilterByStat extends WorkLeaveEvent {
  final WorkLeaveStatType? statType;

  const WorkLeaveEventFilterByStat(this.statType);

  @override
  List<Object?> get props => [statType];
}
