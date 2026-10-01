import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/filter_history_attendance_usecase.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/get_history_attendance_summary_usecase.dart';

part 'history_attendance_event.dart';
part 'history_attendance_state.dart';

class HistoryAttendanceBloc
    extends Bloc<HistoryAttendanceEvent, HistoryAttendanceState> {
  final FilterHistoryAttendanceUsecase filterHistoryAttendanceUsecase;
  final GetHistoryAttendanceSummaryUsecase getHistoryAttendanceSummaryUsecase;

  HistoryAttendanceBloc({
    required this.filterHistoryAttendanceUsecase,
    required this.getHistoryAttendanceSummaryUsecase,
  }) : super(HistoryAttendanceInitialState()) {
    on<HistoryAttendanceEventStarted>((event, emit) {
      emit(HistoryAttendanceEarlyLoadingState());
      emit(
        HistoryAttendanceEarlyLoadedState(
          event.historyEntity,
          event.summaryEntity,
        ),
      );
    });

    on<HistoryAttendanceEventFiltered>((event, emit) async {
      emit(HistoryAttendanceFilterLoadingState());

      String? statusParam;
      if (event.status is AttendanceEnum) {
        statusParam = (event.status as AttendanceEnum).name.toLowerCase();
      } else if (event.status is String) {
        final s = event.status.toString().trim().toLowerCase();
        if (s.isNotEmpty && s != 'all' && s != 'semua' && s != '-- default --') {
          statusParam = s;
        }
      }

      final historyFuture = filterHistoryAttendanceUsecase(
        event.page,
        event.month,
        event.year,
        statusParam,
      );
      final summaryFuture = getHistoryAttendanceSummaryUsecase(
        event.month,
        event.year,
      );

      final results = await Future.wait([historyFuture, summaryFuture]);
      final historyResult =
          results[0] as Either<Failure, AttendanceHistoryEntity>;
      final summaryResult =
          results[1] as Either<Failure, AttendanceSummaryEntity>;

      historyResult.fold(
        (l) => emit(
          HistoryAttendanceFailedFilterState(
            event.historyEntity,
            event.summaryEntity,
          ),
        ),
        (historyData) {
          final updatedSummary = summaryResult.fold(
            (l) => event.summaryEntity,
            (summaryData) => summaryData,
          );

          final MonthEnum? resolvedMonth =
              (event.month != null && event.month! >= 1 && event.month! <= 12)
                  ? MonthEnum.values[event.month! - 1]
                  : null;

          final AttendanceEnum? resolvedStatus = event.status is AttendanceEnum
              ? event.status as AttendanceEnum
              : null;

          emit(
            HistoryAttendanceFilterLoadedState(
              historyData,
              updatedSummary,
              resolvedStatus,
              resolvedMonth,
              event.year ?? DateTime.now().year,
            ),
          );
        },
      );
    });
  }
}

