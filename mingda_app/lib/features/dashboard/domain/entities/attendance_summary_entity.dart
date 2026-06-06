class AttendanceSummaryEntity {
  final int total;
  final int hadir;
  final int terlambat;
  final int izin;
  final int sakit;
  final int alpha;
  final int cuti;
  final int totalLateMinutes;

  const AttendanceSummaryEntity({
    required this.total,
    required this.hadir,
    required this.terlambat,
    required this.izin,
    required this.sakit,
    required this.alpha,
    required this.cuti,
    required this.totalLateMinutes,
  });
}
