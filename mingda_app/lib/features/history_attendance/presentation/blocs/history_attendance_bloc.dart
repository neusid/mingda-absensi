import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/filter_history_attendance_usecase.dart';

part 'history_attendance_event.dart';
part 'history_attendance_state.dart';

class HistoryAttendanceBloc
    extends Bloc<HistoryAttendanceEvent, HistoryAttendanceState> {
  final FilterHistoryAttendanceUsecase filterHistoryAttendanceUsecase;
  HistoryAttendanceBloc({required this.filterHistoryAttendanceUsecase})
    : super(HistoryAttendanceInitialState()) {
    on<HistoryAttendanceEventStarted>((event, emit) {
      // TODO: implement event handler
      emit(HistoryAttendanceEarlyLoadingState());
      emit(
        HistoryAttendanceEarlyLoadedState(
          event.historyEntity,
          event.summaryEntity,
        ),
      );
    });

    on<HistoryAttendanceEventFiltered>((event, emit) async {
      // TODO: implement event handler
      emit(HistoryAttendanceFilterLoadingState());
      final result = await filterHistoryAttendanceUsecase(
        event.page,
        event.month,
        event.year,
        event.status.toString(),
      );
      result.fold(
        (l) => emit(
          HistoryAttendanceFailedFilterState(
            event.historyEntity,
            event.summaryEntity,
          ),
        ),
        (r) {
          emit(
            HistoryAttendanceFilterLoadedState(
              r,
              event.summaryEntity,
              event.status,
              event.month,
              event.year,
            ),
          );
        },
      );
    });
  }
}
