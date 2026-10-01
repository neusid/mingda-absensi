import 'package:mingda_app/features/dashboard/data/datasources/dashboard_dummy_data_source_impl.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_history_model.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';
import 'package:mingda_app/features/history_attendance/data/datasources/history_attendance_remote_data_source.dart';

class HistoryAttendanceDummyDataSourceImpl
    implements HistoryAttendanceRemoteDataSource {
  @override
  Future<AttendanceHistoryModel> filterHistoryAttendanceDatasource(
    int? page,
    int? month,
    int? year,
    String? status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _filterItems(page, month, year, status);
  }

  @override
  Future<AttendanceHistoryModel> paginationHistoryAttendanceDatasource(
    int? page,
    int? month,
    int? year,
    String? status,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _filterItems(page, month, year, status);
  }

  @override
  Future<AttendanceSummaryModel> getAttendanceSummaryDatasource(
    int? month,
    int? year,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    var items = List<AttendanceItemModel>.from(
      DashboardDummyDataSourceImpl.dummyAttendanceItems,
    );

    if (year != null) {
      items = items.where((e) {
        final d = DateTime.tryParse(e.attendanceDate);
        return d != null && d.year == year;
      }).toList();
    }

    if (month != null) {
      items = items.where((e) {
        final d = DateTime.tryParse(e.attendanceDate);
        return d != null && d.month == month;
      }).toList();
    }

    int hadir = 0;
    int terlambat = 0;
    int izin = 0;
    int sakit = 0;
    int alpha = 0;
    int cuti = 0;
    int totalLateMinutes = 0;

    for (final item in items) {
      final s = item.status.toLowerCase();
      if (s == 'hadir') {
        hadir++;
      } else if (s == 'terlambat') {
        terlambat++;
        totalLateMinutes += item.lateMinutes;
      } else if (s == 'izin') {
        izin++;
      } else if (s == 'sakit') {
        sakit++;
      } else if (s == 'alpha') {
        alpha++;
      } else if (s == 'cuti') {
        cuti++;
      }
    }

    return AttendanceSummaryModel(
      total: items.length,
      hadir: hadir,
      terlambat: terlambat,
      izin: izin,
      sakit: sakit,
      alpha: alpha,
      cuti: cuti,
      totalLateMinutes: totalLateMinutes,
    );
  }

  AttendanceHistoryModel _filterItems(
    int? page,
    int? month,
    int? year,
    String? status,
  ) {
    var items = List<AttendanceItemModel>.from(
      DashboardDummyDataSourceImpl.dummyAttendanceItems,
    );

    if (year != null) {
      items = items.where((e) {
        final d = DateTime.tryParse(e.attendanceDate);
        return d != null && d.year == year;
      }).toList();
    }

    if (month != null) {
      items = items.where((e) {
        final d = DateTime.tryParse(e.attendanceDate);
        return d != null && d.month == month;
      }).toList();
    }

    if (status != null &&
        status.isNotEmpty &&
        status.toLowerCase() != 'all' &&
        status.toLowerCase() != 'semua' &&
        status.toLowerCase() != '-- default --') {
      items = items
          .where((e) => e.status.toLowerCase() == status.toLowerCase())
          .toList();
    }

    return AttendanceHistoryModel(
      currentPage: page ?? 1,
      data: items,
      firstPageUrl: '1',
      from: items.isEmpty ? 0 : 1,
      lastPage: 1,
      lastPageUrl: '1',
      links: const [
        AttendanceLinkModel(
          url: null,
          label: '&laquo; Previous',
          page: null,
          active: false,
        ),
        AttendanceLinkModel(
          url: '1',
          label: '1',
          page: 1,
          active: true,
        ),
        AttendanceLinkModel(
          url: null,
          label: 'Next &raquo;',
          page: null,
          active: false,
        ),
      ],
      nextPageUrl: null,
      path: '/mobile/v1/attendance/history',
      perPage: 15,
      prevPageUrl: null,
      to: items.length,
      total: items.length,
    );
  }
}

