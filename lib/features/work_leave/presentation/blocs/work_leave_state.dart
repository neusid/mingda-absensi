part of 'work_leave_bloc.dart';

abstract class WorkLeaveState extends Equatable {
  const WorkLeaveState();

  @override
  List<Object?> get props => [];
}

class WorkLeaveInitialState extends WorkLeaveState {}

class WorkLeaveLoadingState extends WorkLeaveState {}

class WorkLeaveLoadedState extends WorkLeaveState {
  final List<LeaveItemEntity> allLeaves;
  final List<LeaveItemEntity> filteredLeaves;
  final LeaveSummaryEntity summary;
  final WorkLeaveStatType? selectedStat;
  final String selectedStatusDropdown;
  final int? selectedMonth;
  final int? selectedYear;

  const WorkLeaveLoadedState({
    required this.allLeaves,
    required this.filteredLeaves,
    required this.summary,
    this.selectedStat,
    this.selectedStatusDropdown = 'Semua Status',
    this.selectedMonth,
    this.selectedYear,
  });

  WorkLeaveLoadedState copyWith({
    List<LeaveItemEntity>? allLeaves,
    List<LeaveItemEntity>? filteredLeaves,
    LeaveSummaryEntity? summary,
    WorkLeaveStatType? Function()? selectedStat,
    String? selectedStatusDropdown,
    int? selectedMonth,
    int? selectedYear,
  }) {
    return WorkLeaveLoadedState(
      allLeaves: allLeaves ?? this.allLeaves,
      filteredLeaves: filteredLeaves ?? this.filteredLeaves,
      summary: summary ?? this.summary,
      selectedStat: selectedStat != null ? selectedStat() : this.selectedStat,
      selectedStatusDropdown: selectedStatusDropdown ?? this.selectedStatusDropdown,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }

  @override
  List<Object?> get props => [
        allLeaves,
        filteredLeaves,
        summary,
        selectedStat,
        selectedStatusDropdown,
        selectedMonth,
        selectedYear,
      ];
}

class WorkLeaveFailureState extends WorkLeaveState {
  final String message;

  const WorkLeaveFailureState(this.message);

  @override
  List<Object?> get props => [message];
}
