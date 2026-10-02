import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';

class SubmitLeaveRequestUseCase {
  final WorkLeaveRepository repository;

  SubmitLeaveRequestUseCase({required this.repository});

  Future<Either<Failure, LeaveItemEntity>> call({
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    String? attachmentPath,
  }) {
    return repository.submitLeaveRequest(
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      attachmentPath: attachmentPath,
    );
  }
}
