import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_summary_entity.dart';
import 'package:mingda_app/features/work_leave/domain/usecases/get_leave_list_usecase.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_stat_card.dart';

part 'work_leave_event.dart';
part 'work_leave_state.dart';

class WorkLeaveBloc extends Bloc<WorkLeaveEvent, WorkLeaveState> {
  final GetLeaveListUseCase getLeaveListUseCase;

  WorkLeaveBloc({required this.getLeaveListUseCase})
      : super(WorkLeaveInitialState()) {
    on<WorkLeaveEventFetch>(_onFetch);
    on<WorkLeaveEventFilterByStat>(_onFilterByStat);
  }

  Future<void> _onFetch(
    WorkLeaveEventFetch event,
    Emitter<WorkLeaveState> emit,
  ) async {
    emit(WorkLeaveLoadingState());

    final result = await getLeaveListUseCase(
      month: event.month,
      year: event.year,
      status: event.status,
    );

    result.fold(
      (failure) => emit(WorkLeaveFailureState(failure.message)),
      (leaves) {
        final summary = LeaveSummaryEntity.fromLeaveList(leaves);
        emit(
          WorkLeaveLoadedState(
            allLeaves: leaves,
            filteredLeaves: leaves,
            summary: summary,
            selectedMonth: event.month,
            selectedYear: event.year,
          ),
        );
      },
    );
  }

  void _onFilterByStat(
    WorkLeaveEventFilterByStat event,
    Emitter<WorkLeaveState> emit,
  ) {
    final current = state;
    if (current is! WorkLeaveLoadedState) return;

    final targetStat = current.selectedStat == event.statType ? null : event.statType;
    List<LeaveItemEntity> filtered = current.allLeaves;

    if (targetStat != null) {
      switch (targetStat) {
        case WorkLeaveStatType.disetujui:
          filtered = current.allLeaves
              .where((i) => i.displayStatus == 'Disetujui')
              .toList();
          break;
        case WorkLeaveStatType.menunggu:
          filtered = current.allLeaves
              .where((i) => i.displayStatus == 'Menunggu')
              .toList();
          break;
        case WorkLeaveStatType.ditolak:
          filtered = current.allLeaves
              .where((i) => i.displayStatus == 'Ditolak')
              .toList();
          break;
        case WorkLeaveStatType.cutiTerpakai:
          filtered = current.allLeaves
              .where((i) => i.leaveType.toLowerCase().contains('cuti'))
              .toList();
          break;
      }
    }

    emit(
      current.copyWith(
        selectedStat: () => targetStat,
        filteredLeaves: filtered,
      ),
    );
  }
}
