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
