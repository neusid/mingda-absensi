import 'package:mingda_app/core/utils/json_parser.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';

class AttendanceSummaryModel extends AttendanceSummaryEntity {
  const AttendanceSummaryModel({
    required super.total,
    required super.hadir,
    required super.terlambat,
    required super.izin,
    required super.sakit,
    required super.alpha,
    required super.cuti,
    required super.totalLateMinutes,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AttendanceSummaryModel(
      total: parseIntValue(data['total']),
      hadir: parseIntValue(data['hadir']),
      terlambat: parseIntValue(data['terlambat']),
      izin: parseIntValue(data['izin']),
      sakit: parseIntValue(data['sakit']),
      alpha: parseIntValue(data['alpha']),
      cuti: parseIntValue(data['cuti']),
      totalLateMinutes: parseIntValue(data['total_late_minutes']),
    );
  }
}
