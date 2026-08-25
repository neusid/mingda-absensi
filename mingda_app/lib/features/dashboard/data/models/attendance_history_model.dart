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
    final data = json['data'] as Map<String, dynamic>;
    return AttendanceHistoryModel(
      currentPage: parseIntValue(data['current_page']),
      data: (data['data'] as List)
          .map((e) => AttendanceItemModel.fromJson(e))
          .toList(),
      firstPageUrl: data['first_page_url'],
      from: parseIntValue(data['from']),
      lastPage: parseIntValue(data['last_page']),
      lastPageUrl: data['last_page_url'],
      links: (data['links'] as List)
          .map((e) => AttendanceLinkModel.fromJson(e))
          .toList(),
      nextPageUrl: data['next_page_url'],
      path: data['path'],
      perPage: parseIntValue(data['per_page']),
      prevPageUrl: data['prev_page_url'],
      to: parseIntValue(data['to']),
      total: parseIntValue(data['total']),
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
