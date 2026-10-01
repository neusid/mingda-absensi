import 'package:mingda_app/core/utils/json_parser.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';

class AttendanceHistoryModel extends AttendanceHistoryEntity {
  const AttendanceHistoryModel({
    required super.currentPage,
    required super.data,
    required super.firstPageUrl,
    required super.from,
    required super.lastPage,
    required super.lastPageUrl,
    required super.links,
    super.nextPageUrl,
    required super.path,
    required super.perPage,
    super.prevPageUrl,
    required super.to,
    required super.total,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> paginationMap = {};
    List rawList = [];

    final rawData = json['data'];
    if (rawData is Map<String, dynamic>) {
      paginationMap = rawData;
      if (rawData['data'] is List) {
        rawList = rawData['data'] as List;
      }
    } else if (rawData is List) {
      rawList = rawData;
      paginationMap = json;
    } else if (json['data'] is List) {
      rawList = json['data'] as List;
      paginationMap = json;
    }

    final rawLinks = paginationMap['links'];
    final List<AttendanceLinkModel> links = (rawLinks is List)
        ? rawLinks
            .whereType<Map<String, dynamic>>()
            .map((e) => AttendanceLinkModel.fromJson(e))
            .toList()
        : [];

    return AttendanceHistoryModel(
      currentPage: parseIntValue(paginationMap['current_page'] ?? 1),
      data: rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => AttendanceItemModel.fromJson(e))
          .toList(),
      firstPageUrl: paginationMap['first_page_url']?.toString() ?? '',
      from: parseIntValue(paginationMap['from']),
      lastPage: parseIntValue(paginationMap['last_page'] ?? 1),
      lastPageUrl: paginationMap['last_page_url']?.toString() ?? '',
      links: links,
      nextPageUrl: paginationMap['next_page_url']?.toString(),
      path: paginationMap['path']?.toString() ?? '',
      perPage: parseIntValue(paginationMap['per_page'] ?? 10),
      prevPageUrl: paginationMap['prev_page_url']?.toString(),
      to: parseIntValue(paginationMap['to']),
      total: parseIntValue(paginationMap['total'] ?? rawList.length),
    );
  }
}

class AttendanceItemModel extends AttendanceItemEntity {
  const AttendanceItemModel({
    required super.id,
    required super.employeeId,
    required super.attendanceDate,
    super.checkIn,
    super.checkOut,
    required super.status,
    super.notes,
    super.photoIn,
    super.photoOut,
    super.locationIn,
    super.gpsAccuracyIn,
    required super.isMockedIn,
    super.gpsWarningsIn,
    required super.isSuspiciousIn,
    super.locationOut,
    super.gpsAccuracyOut,
    required super.isMockedOut,
    super.gpsWarningsOut,
    required super.isSuspiciousOut,
    required super.lateMinutes,
    required super.overtimeMinutes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AttendanceItemModel.fromJson(Map<String, dynamic> json) {
    return AttendanceItemModel(
      id: parseIntValue(json['id']),
      employeeId: parseIntValue(json['employee_id']),
      attendanceDate: json['attendance_date'] ?? '',
      checkIn: json['check_in'],
      checkOut: json['check_out'],
      status: json['status'] ?? '',
      notes: json['notes'],
      photoIn: json['photo_in'],
      photoOut: json['photo_out'],
      locationIn: json['location_in'],
      gpsAccuracyIn: parseDoubleValue(json['gps_accuracy_in']),
      isMockedIn: parseBoolValue(json['is_mocked_in']),
      gpsWarningsIn: json['gps_warnings_in'],
      isSuspiciousIn: parseBoolValue(json['is_suspicious_in']),
      locationOut: json['location_out'],
      gpsAccuracyOut: parseDoubleValue(json['gps_accuracy_out']),
      isMockedOut: parseBoolValue(json['is_mocked_out']),
      gpsWarningsOut: json['gps_warnings_out'],
      isSuspiciousOut: parseBoolValue(json['is_suspicious_out']),
      lateMinutes: parseIntValue(json['late_minutes']),
      overtimeMinutes: parseIntValue(json['overtime_minutes']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AttendanceLinkModel extends AttendanceLinkEntity {
  const AttendanceLinkModel({
    super.url,
    required super.label,
    super.page,
    required super.active,
  });

  factory AttendanceLinkModel.fromJson(Map<String, dynamic> json) {
    return AttendanceLinkModel(
      url: json['url'],
      label: json['label'] ?? '',
      page: json['page'] == null ? null : parseIntValue(json['page']),
      active: parseBoolValue(json['active']),
    );
  }
}
