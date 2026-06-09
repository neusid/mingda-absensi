import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';

part 'history_attendance_event.dart';
part 'history_attendance_state.dart';

class HistoryAttendanceBloc
    extends Bloc<HistoryAttendanceEvent, HistoryAttendanceState> {
  HistoryAttendanceBloc() : super(HistoryAttendanceInitialState()) {
    on<HistoryAttendanceEventStarted>((event, emit) {
      // TODO: implement event handler
      emit(HistoryAttendanceLoadingState());
      emit(
        HistoryAttendanceSuccessState(event.historyEntity, event.summaryEntity),
      );
    });
  }
}
