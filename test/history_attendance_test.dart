import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_dummy_data_source_impl.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/repositories/history_attendance_repository.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/filter_history_attendance_usecase.dart';
import 'package:mingda_app/features/history_attendance/domain/usecases/get_history_attendance_summary_usecase.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';

class FakeHistoryAttendanceRepository implements HistoryAttendanceRepository {
  final AttendanceHistoryEntity mockHistory;
  final AttendanceSummaryEntity mockSummary;

  FakeHistoryAttendanceRepository({
    required this.mockHistory,
    required this.mockSummary,
  });

  @override
  Future<Either<Failure, AttendanceHistoryEntity>>
  filterHistoryAttendanceRepository(
    int? page,
    int? month,
    int? year,
    String? status,
  ) async {
    return Right(mockHistory);
  }

  @override
  Future<Either<Failure, AttendanceHistoryEntity>>
  paginationHistoryAttendanceRepository(
    int? page,
    int? month,
    int? year,
    String? status,
  ) async {
    return Right(mockHistory);
  }

  @override
  Future<Either<Failure, AttendanceSummaryEntity>>
  getAttendanceSummaryRepository(int? month, int? year) async {
    return Right(mockSummary);
  }
}

void main() {
  test('HistoryAttendanceDummyDataSourceImpl getAttendanceSummaryDatasource returns calculated summary', () async {
    final ds = HistoryAttendanceDummyDataSourceImpl();
    final summary = await ds.getAttendanceSummaryDatasource(10, 2026);

    expect(summary, isNotNull);
    expect(summary.total >= 0, isTrue);
  });

  test('HistoryAttendanceBloc updates both history and summary on HistoryAttendanceEventFiltered', () async {
    const initialSummary = AttendanceSummaryEntity(
      total: 10,
      hadir: 8,
      terlambat: 2,
      izin: 0,
      sakit: 0,
      alpha: 0,
      cuti: 0,
      totalLateMinutes: 10,
    );

    const updatedSummary = AttendanceSummaryEntity(
      total: 20,
      hadir: 18,
      terlambat: 1,
      izin: 1,
      sakit: 0,
      alpha: 0,
      cuti: 0,
      totalLateMinutes: 5,
    );

    const mockHistory = AttendanceHistoryModel(
      currentPage: 1,
      data: [],
      firstPageUrl: '',
      from: 0,
      lastPage: 1,
      lastPageUrl: '',
      links: [],
      nextPageUrl: null,
      path: '',
      perPage: 15,
      prevPageUrl: null,
      to: 0,
      total: 0,
    );

    final repo = FakeHistoryAttendanceRepository(
      mockHistory: mockHistory,
      mockSummary: updatedSummary,
    );

    final bloc = HistoryAttendanceBloc(
      filterHistoryAttendanceUsecase: FilterHistoryAttendanceUsecase(
        historyAttendanceRepository: repo,
      ),
      getHistoryAttendanceSummaryUsecase: GetHistoryAttendanceSummaryUsecase(
        historyAttendanceRepository: repo,
      ),
    );

    bloc.add(
      const HistoryAttendanceEventStarted(
        historyEntity: mockHistory,
        summaryEntity: initialSummary,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HistoryAttendanceEarlyLoadingState>(),
        isA<HistoryAttendanceEarlyLoadedState>(),
      ]),
    );

    bloc.add(
      const HistoryAttendanceEventFiltered(
        historyEntity: mockHistory,
        summaryEntity: initialSummary,
        page: 1,
        month: 5,
        year: 2026,
        status: null,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HistoryAttendanceFilterLoadingState>(),
        predicate<HistoryAttendanceFilterLoadedState>((state) {
          return state.summaryEntity.hadir == 18 &&
              state.summaryEntity.total == 20 &&
              state.yearsSelected == 2026;
        }),
      ]),
    );

    bloc.add(
      const HistoryAttendanceEventFiltered(
        historyEntity: mockHistory,
        summaryEntity: initialSummary,
        page: 1,
        month: null,
        year: 2026,
        status: AttendanceEnum.Hadir,
      ),
    );

    await expectLater(
      bloc.stream,
      emitsInOrder([
        isA<HistoryAttendanceFilterLoadingState>(),
        predicate<HistoryAttendanceFilterLoadedState>((state) {
          return state.attendanceSelected == AttendanceEnum.Hadir &&
              state.monthSelected == null &&
              state.yearsSelected == 2026;
        }),
      ]),
    );
  });
}

