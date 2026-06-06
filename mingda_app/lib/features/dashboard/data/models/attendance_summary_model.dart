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
      total: data['total'],
      hadir: data['hadir'],
      terlambat: data['terlambat'],
      izin: data['izin'],
      sakit: data['sakit'],
      alpha: data['alpha'],
      cuti: data['cuti'],
      totalLateMinutes: data['total_late_minutes'],
    );
  }
}
