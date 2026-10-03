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

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': data
          .map((e) => e is AttendanceItemModel
              ? e.toJson()
              : AttendanceItemModel(
                  id: e.id,
                  employeeId: e.employeeId,
                  attendanceDate: e.attendanceDate,
                  checkIn: e.checkIn,
                  checkOut: e.checkOut,
                  status: e.status,
                  notes: e.notes,
                  photoIn: e.photoIn,
                  photoOut: e.photoOut,
                  locationIn: e.locationIn,
                  gpsAccuracyIn: e.gpsAccuracyIn,
                  isMockedIn: e.isMockedIn,
                  gpsWarningsIn: e.gpsWarningsIn,
                  isSuspiciousIn: e.isSuspiciousIn,
                  locationOut: e.locationOut,
                  gpsAccuracyOut: e.gpsAccuracyOut,
                  isMockedOut: e.isMockedOut,
                  gpsWarningsOut: e.gpsWarningsOut,
                  isSuspiciousOut: e.isSuspiciousOut,
                  lateMinutes: e.lateMinutes,
                  overtimeMinutes: e.overtimeMinutes,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                ).toJson())
          .toList(),
      'first_page_url': firstPageUrl,
      'from': from,
      'last_page': lastPage,
      'last_page_url': lastPageUrl,
      'links': links
          .map((e) => e is AttendanceLinkModel
              ? e.toJson()
              : AttendanceLinkModel(
                  url: e.url,
                  label: e.label,
                  page: e.page,
                  active: e.active,
                ).toJson())
          .toList(),
      'next_page_url': nextPageUrl,
      'path': path,
      'per_page': perPage,
      'prev_page_url': prevPageUrl,
      'to': to,
      'total': total,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'attendance_date': attendanceDate,
      'check_in': checkIn,
      'check_out': checkOut,
      'status': status,
      'notes': notes,
      'photo_in': photoIn,
      'photo_out': photoOut,
      'location_in': locationIn,
      'gps_accuracy_in': gpsAccuracyIn,
      'is_mocked_in': isMockedIn,
      'gps_warnings_in': gpsWarningsIn,
      'is_suspicious_in': isSuspiciousIn,
      'location_out': locationOut,
      'gps_accuracy_out': gpsAccuracyOut,
      'is_mocked_out': isMockedOut,
      'gps_warnings_out': gpsWarningsOut,
      'is_suspicious_out': isSuspiciousOut,
      'late_minutes': lateMinutes,
      'overtime_minutes': overtimeMinutes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
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

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'label': label,
      'page': page,
      'active': active,
    };
  }
}
