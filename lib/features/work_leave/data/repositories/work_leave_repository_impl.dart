import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/core/network/network_info.dart';
import 'package:mingda_app/core/storage/hive_constants.dart';
import 'package:mingda_app/core/storage/local_cache_service.dart';
import 'package:mingda_app/core/storage/offline_queue_item.dart';
import 'package:mingda_app/core/storage/sync_manager.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/data/models/leave_item_model.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';
import 'package:mingda_app/features/work_leave/domain/repositories/work_leave_repository.dart';

class WorkLeaveRepositoryImpl implements WorkLeaveRepository {
  final WorkLeaveRemoteDataSource remoteDataSource;
  final LocalCacheService? localCacheService;
  final SyncManager? syncManager;
  final NetworkInfo? networkInfo;

  WorkLeaveRepositoryImpl({
    required this.remoteDataSource,
    this.localCacheService,
    this.syncManager,
    this.networkInfo,
  }) {
    syncManager?.registerHandler(HiveConstants.actionSubmitLeave, (item) async {
      try {
        final payload = item.payload;
        await remoteDataSource.submitLeaveRequest(
          leaveType: payload['leaveType']?.toString() ?? 'cuti',
          startDate: payload['startDate']?.toString() ?? '',
          endDate: payload['endDate']?.toString() ?? '',
          reason: payload['reason']?.toString() ?? '',
          attachmentPath: payload['attachmentPath']?.toString(),
        );
        return true;
      } catch (e) {
        return false;
      }
    });
  }

  @override
  Future<Either<Failure, List<LeaveItemEntity>>> getLeaveList({
    int? month,
    int? year,
    String? status,
  }) async {
    try {
      final isOnline = await networkInfo?.isConnected ?? true;
      if (isOnline) {
        try {
          final models = await remoteDataSource.getLeaveList(
            month: month,
            year: year,
            status: status,
          );
          if (localCacheService != null) {
            await localCacheService!.put(
              HiveConstants.workLeaveListKey,
              models.map((m) => m.toJson()).toList(),
            );
          }
          final entities = models.map((m) => m.toDomain()).toList();
          return Right(entities);
        } catch (e) {
          final cached =
              localCacheService?.getMapList(HiveConstants.workLeaveListKey);
          if (cached != null) {
            return Right(
              cached
                  .map((m) => LeaveItemModel.fromJson(m).toDomain())
                  .toList(),
            );
          }
          rethrow;
        }
      } else {
        // Offline: Return cache and prepend pending offline requests
        final cached =
            localCacheService?.getMapList(HiveConstants.workLeaveListKey);
        final list = (cached ?? [])
            .map((m) => LeaveItemModel.fromJson(m).toDomain())
            .toList();

        if (syncManager != null) {
          final pending = await syncManager!.getPendingQueue();
          for (final item in pending) {
            if (item.actionType == HiveConstants.actionSubmitLeave) {
              list.insert(
                0,
                LeaveItemEntity(
                  id: int.tryParse(item.id.replaceAll(RegExp(r'\D'), '')) ??
                      DateTime.now().millisecondsSinceEpoch,
                  leaveType: item.payload['leaveType']?.toString() ?? 'cuti',
                  startDate: item.payload['startDate']?.toString() ?? '',
                  endDate: item.payload['endDate']?.toString() ?? '',
                  reason: item.payload['reason']?.toString() ?? '',
                  status: 'Menunggu Sinkronisasi',
                  createdAt: item.createdAt.toIso8601String(),
                ),
              );
            }
          }
        }
        return Right(list);
      }
    } on Failure catch (f) {
      final cached =
          localCacheService?.getMapList(HiveConstants.workLeaveListKey);
      if (cached != null) {
        return Right(
          cached.map((m) => LeaveItemModel.fromJson(m).toDomain()).toList(),
        );
      }
      return Left(f);
    } catch (e) {
      final cached =
          localCacheService?.getMapList(HiveConstants.workLeaveListKey);
      if (cached != null) {
        return Right(
          cached.map((m) => LeaveItemModel.fromJson(m).toDomain()).toList(),
        );
      }
      return Left(ServerFailure('Gagal mengambil data cuti: $e'));
    }
  }

  @override
  Future<Either<Failure, LeaveItemEntity>> submitLeaveRequest({
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    String? attachmentPath,
  }) async {
    try {
      final isOnline = await networkInfo?.isConnected ?? true;
      if (isOnline) {
        try {
          final model = await remoteDataSource.submitLeaveRequest(
            leaveType: leaveType,
            startDate: startDate,
            endDate: endDate,
            reason: reason,
            attachmentPath: attachmentPath,
          );
          return Right(model.toDomain());
        } catch (e) {
          // If remote submission failed due to network, enqueue offline
          if (syncManager != null) {
            final queueItem = OfflineQueueItem(
              id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
              actionType: HiveConstants.actionSubmitLeave,
              payload: {
                'leaveType': leaveType,
                'startDate': startDate,
                'endDate': endDate,
                'reason': reason,
                'attachmentPath': attachmentPath,
              },
              createdAt: DateTime.now(),
            );
            await syncManager!.enqueue(queueItem);
            return Right(LeaveItemEntity(
              id: DateTime.now().millisecondsSinceEpoch,
              leaveType: leaveType,
              startDate: startDate,
              endDate: endDate,
              reason: reason,
              status: 'Menunggu Sinkronisasi',
              createdAt: DateTime.now().toIso8601String(),
            ));
          }
          rethrow;
        }
      } else {
        // Offline: enqueue into sync manager
        if (syncManager != null) {
          final queueItem = OfflineQueueItem(
            id: 'leave_${DateTime.now().millisecondsSinceEpoch}',
            actionType: HiveConstants.actionSubmitLeave,
            payload: {
              'leaveType': leaveType,
              'startDate': startDate,
              'endDate': endDate,
              'reason': reason,
              'attachmentPath': attachmentPath,
            },
            createdAt: DateTime.now(),
          );
          await syncManager!.enqueue(queueItem);
        }
        return Right(LeaveItemEntity(
          id: DateTime.now().millisecondsSinceEpoch,
          leaveType: leaveType,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
          status: 'Menunggu Sinkronisasi',
          createdAt: DateTime.now().toIso8601String(),
        ));
      }
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure('Gagal mengajukan permohonan cuti: $e'));
    }
  }
}
