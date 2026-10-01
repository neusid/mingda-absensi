import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';

class GetLeaveListUseCase {
  final WorkLeaveRepository repository;

  GetLeaveListUseCase({required this.repository});

  Future<Either<Failure, List<LeaveItemEntity>>> call({
    int? month,
    int? year,
    String? status,
  }) {
    return repository.getLeaveList(
      month: month,
      year: year,
      status: status,
    );
  }
}
