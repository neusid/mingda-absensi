import 'package:mingda_app/features/work_leave/data/models/leave_item_model.dart';

abstract class WorkLeaveRemoteDataSource {
  Future<List<LeaveItemModel>> getLeaveList({
    int? month,
    int? year,
    String? status,
  });

  Future<LeaveItemModel> submitLeaveRequest({
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    String? attachmentPath,
  });
}
