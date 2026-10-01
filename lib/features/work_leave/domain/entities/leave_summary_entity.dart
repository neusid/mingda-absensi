import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';

class LeaveSummaryEntity extends Equatable {
  final int approved;
  final int pending;
  final int rejected;
  final int leaveTaken;

  const LeaveSummaryEntity({
    required this.approved,
    required this.pending,
    required this.rejected,
    required this.leaveTaken,
  });

  /// Kalkulasi otomatis dari daftar leave item aktual
  factory LeaveSummaryEntity.fromLeaveList(List<LeaveItemEntity> list) {
    int approved = 0;
    int pending = 0;
    int rejected = 0;
    int leaveTaken = 0;

    for (final item in list) {
      final s = item.status.toLowerCase();
      final t = item.leaveType.toLowerCase();

      if (s == 'approved' || s == 'disetujui') {
        approved++;
        if (t.contains('cuti')) {
          leaveTaken++;
        }
      } else if (s == 'rejected' || s == 'ditolak') {
        rejected++;
      } else {
        pending++;
      }
    }

    return LeaveSummaryEntity(
      approved: approved,
      pending: pending,
      rejected: rejected,
      leaveTaken: leaveTaken,
    );
  }

  @override
  List<Object?> get props => [approved, pending, rejected, leaveTaken];
}
