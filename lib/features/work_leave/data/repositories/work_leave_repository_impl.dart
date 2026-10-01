import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';

class WorkLeaveRepositoryImpl implements WorkLeaveRepository {
  final WorkLeaveRemoteDataSource remoteDataSource;

  WorkLeaveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveList({
    int? month,
    int? year,
    String? status,
  }) async {
    try {
      final models = await remoteDataSource.getLeaveList(
        month: month,
        year: year,
        status: status,
      );
      final entities = models.map((m) => m.toDomain()).toList();
      return Right(entities);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Gagal mengambil data cuti: $e'));
    }
  }
}
