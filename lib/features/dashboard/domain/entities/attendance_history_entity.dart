import 'package:mingda_app/core/localization/app_language.dart';

class AttendanceHistoryEntity {
  final int currentPage;
  final List<AttendanceItemEntity> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<AttendanceLinkEntity> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int total;

  const AttendanceHistoryEntity({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });
}

class AttendanceItemEntity {
  final int id;
  final int employeeId;
  final String attendanceDate;
  final String? checkIn;
  final String? checkOut;
  final String status;
  final String? notes;
  final String? photoIn;
  final String? photoOut;
  final String? locationIn;
  final double? gpsAccuracyIn;
  final bool isMockedIn;
  final String? gpsWarningsIn;
  final bool isSuspiciousIn;
  final String? locationOut;
  final double? gpsAccuracyOut;
  final bool isMockedOut;
  final String? gpsWarningsOut;
  final bool isSuspiciousOut;
  final int lateMinutes;
  final int overtimeMinutes;
  final String createdAt;
  final String updatedAt;

  const AttendanceItemEntity({
    required this.id,
    required this.employeeId,
    required this.attendanceDate,
    this.checkIn,
    this.checkOut,
    required this.status,
    this.notes,
    this.photoIn,
    this.photoOut,
    this.locationIn,
    this.gpsAccuracyIn,
    required this.isMockedIn,
    this.gpsWarningsIn,
    required this.isSuspiciousIn,
    this.locationOut,
    this.gpsAccuracyOut,
    required this.isMockedOut,
    this.gpsWarningsOut,
    required this.isSuspiciousOut,
    required this.lateMinutes,
    required this.overtimeMinutes,
    required this.createdAt,
    required this.updatedAt,
  });

  String localizedStatus(AppLanguage lang) {
    final lower = status.toLowerCase().trim();
    switch (lang) {
      case AppLanguage.en:
        if (lower.contains('hadir') || lower.contains('present')) return 'Present';
        if (lower.contains('terlambat') || lower.contains('late')) return 'Late';
        if (lower.contains('alpha') || lower.contains('absent')) return 'Absent';
        if (lower.contains('izin') || lower.contains('permit')) return 'Permit';
        if (lower.contains('cuti') || lower.contains('leave')) return 'Leave';
        if (lower.contains('sakit') || lower.contains('sick')) return 'Sick';
        return status;
      case AppLanguage.zh:
        if (lower.contains('hadir') || lower.contains('present')) return '出勤';
        if (lower.contains('terlambat') || lower.contains('late')) return '迟到';
        if (lower.contains('alpha') || lower.contains('absent')) return '旷工';
        if (lower.contains('izin') || lower.contains('permit')) return '请假';
        if (lower.contains('cuti') || lower.contains('leave')) return '休假';
        if (lower.contains('sakit') || lower.contains('sick')) return '病假';
        return status;
      case AppLanguage.id:
        return status;
    }
  }

  String? localizedNotes(AppLanguage lang) {
    if (notes == null || notes!.trim().isEmpty) return notes;
    if (lang == AppLanguage.id) return notes;
    final lower = notes!.toLowerCase().trim();
    if (lower.contains('tepat waktu')) {
      return lang == AppLanguage.zh ? '准时出勤' : 'On Time';
    }
    if (lower.contains('terlambat')) {
      if (lateMinutes > 0) {
        return lang == AppLanguage.zh
            ? '迟到 $lateMinutes 分钟'
            : 'Late $lateMinutes minutes';
      }
      return lang == AppLanguage.zh ? '迟到' : 'Late';
    }
    return notes;
  }
}

class AttendanceLinkEntity {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  const AttendanceLinkEntity({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });
}
