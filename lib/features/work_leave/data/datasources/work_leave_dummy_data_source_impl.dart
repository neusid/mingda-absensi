import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/data/models/leave_item_model.dart';

class WorkLeaveDummyDataSourceImpl implements WorkLeaveRemoteDataSource {
  @override
  Future<List<LeaveItemModel>> getLeaveList({
    int? month,
    int? year,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    final sample = [
      const LeaveItemModel(
        id: 1,
        employeeId: 1,
        leaveType: 'sakit',
        startDate: '2026-04-10',
        endDate: '2026-04-11',
        reason: 'Izin Sakit Flu & Demam',
        status: 'approved',
      ),
      const LeaveItemModel(
        id: 2,
        employeeId: 1,
        leaveType: 'cuti',
        startDate: '2026-04-20',
        endDate: '2026-04-23',
        reason: 'Cuti Tahunan Pulang Kampung',
        status: 'pending',
      ),
      const LeaveItemModel(
        id: 3,
        employeeId: 1,
        leaveType: 'izin',
        startDate: '2026-04-05',
        endDate: '2026-04-05',
        reason: 'Izin Keperluan Mendesak',
        status: 'rejected',
      ),
      const LeaveItemModel(
        id: 4,
        employeeId: 1,
        leaveType: 'cuti',
        startDate: '2026-04-01',
        endDate: '2026-04-02',
        reason: 'Cuti Bersama',
        status: 'approved',
      ),
    ];

    if (status != null && status.isNotEmpty && status.toLowerCase() != 'semua status') {
      final s = status.toLowerCase();
      return sample.where((item) {
        if (s.contains('setuju') || s == 'approved') return item.status == 'approved';
        if (s.contains('tunggu') || s == 'pending') return item.status == 'pending';
        if (s.contains('tolak') || s == 'rejected') return item.status == 'rejected';
        return true;
      }).toList();
    }

    return sample;
  }
}
