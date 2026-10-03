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
    final rawData = json['data'];
    final Map<String, dynamic> data = (rawData is Map<String, dynamic>)
        ? rawData
        : (json.containsKey('present') || json.containsKey('hadir') ? json : {});

    final hadir = parseIntValue(data['hadir'] ?? data['present']);
    final terlambat = parseIntValue(data['terlambat'] ?? data['late']);
    final izin = parseIntValue(data['izin']);
    final sakit = parseIntValue(data['sakit'] ?? data['sick']);
    final alpha = parseIntValue(data['alpha']);
    final cuti = parseIntValue(data['cuti'] ?? data['leave']);
    final totalLateMinutes = parseIntValue(
      data['total_late_minutes'] ?? data['late_minutes'] ?? data['overtime_hours'],
    );
    final total = parseIntValue(
      data['total'] ?? (hadir + terlambat + izin + sakit + alpha + cuti),
    );

    return AttendanceSummaryModel(
      total: total,
      hadir: hadir,
      terlambat: terlambat,
      izin: izin,
      sakit: sakit,
      alpha: alpha,
      cuti: cuti,
      totalLateMinutes: totalLateMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'hadir': hadir,
      'terlambat': terlambat,
      'izin': izin,
      'sakit': sakit,
      'alpha': alpha,
      'cuti': cuti,
      'total_late_minutes': totalLateMinutes,
    };
  }
}
