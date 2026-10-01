import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';

abstract class WorkLeaveRepository {
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveList({
    int? month,
    int? year,
    String? status,
  });
}
