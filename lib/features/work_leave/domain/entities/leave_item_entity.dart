import 'package:equatable/equatable.dart';

class LeaveItemEntity extends Equatable {
  final int id;
  final int? employeeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String? attachment;
  final String? createdAt;
  final String? updatedAt;

  const LeaveItemEntity({
    required this.id,
    this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  /// Label yang ramah ditampilkan pada UI (misal: 'Izin Sakit', 'Cuti Tahunan', 'Izin')
  String get displayTitle {
    final lower = leaveType.toLowerCase();
    if (lower.contains('sakit')) {
      return 'Izin Sakit';
    } else if (lower.contains('cuti')) {
      return 'Cuti Tahunan';
    } else if (lower.contains('izin')) {
      return 'Izin Kerja';
    }
    return reason.isNotEmpty ? reason : 'Pengajuan Cuti / Izin';
  }

  /// Status terstandardisasi dalam bahasa Indonesia
  String get displayStatus {
    final lower = status.toLowerCase();
    if (lower == 'approved' || lower == 'disetujui') {
      return 'Disetujui';
    } else if (lower == 'rejected' || lower == 'ditolak') {
      return 'Ditolak';
    } else {
      return 'Menunggu';
    }
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        leaveType,
        startDate,
        endDate,
        reason,
        status,
        attachment,
        createdAt,
        updatedAt,
      ];
}
