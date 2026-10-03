import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mingda_app/core/storage/hive_constants.dart';
import 'package:mingda_app/core/storage/offline_queue_item.dart';

typedef QueueItemHandler = Future<bool> Function(OfflineQueueItem item);

abstract class SyncManager {
  Future<void> init();
  Future<void> enqueue(OfflineQueueItem item);
  Future<List<OfflineQueueItem>> getPendingQueue();
  Future<void> removeQueueItem(String id);
  void registerHandler(String actionType, QueueItemHandler handler);
  Future<int> syncPendingQueue();
  ValueListenable<Box>? listenToQueue();
}

class SyncManagerImpl implements SyncManager {
  Box? _queueBox;
  final Map<String, QueueItemHandler> _handlers = {};

  Box? get queueBox {
    if (_queueBox != null && _queueBox!.isOpen) {
      return _queueBox;
    }
    if (Hive.isBoxOpen(HiveConstants.offlineQueueBoxName)) {
      _queueBox = Hive.box(HiveConstants.offlineQueueBoxName);
      return _queueBox;
    }
    return null;
  }

  @override
  Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(HiveConstants.offlineQueueBoxName)) {
        _queueBox = await Hive.openBox(HiveConstants.offlineQueueBoxName);
      } else {
        _queueBox = Hive.box(HiveConstants.offlineQueueBoxName);
      }
    } catch (e) {
      debugPrint('Error opening Hive queue box: $e');
    }
  }

  @override
  Future<void> enqueue(OfflineQueueItem item) async {
    try {
      final box = queueBox;
      if (box == null) return;
      await box.put(item.id, item.toMap());
    } catch (e) {
      debugPrint('Error enqueueing offline item: $e');
    }
  }

  @override
  Future<List<OfflineQueueItem>> getPendingQueue() async {
    try {
      final box = queueBox;
      if (box == null) return [];
      final items = <OfflineQueueItem>[];
      for (final key in box.keys) {
        final raw = box.get(key);
        if (raw is Map) {
          items.add(OfflineQueueItem.fromMap(raw));
        }
      }
      // Sort FIFO by createdAt
      items.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return items;
    } catch (e) {
      debugPrint('Error reading pending queue: $e');
      return [];
    }
  }

  @override
  Future<void> removeQueueItem(String id) async {
    try {
      final box = queueBox;
      if (box == null) return;
      await box.delete(id);
    } catch (e) {
      debugPrint('Error deleting queue item $id: $e');
    }
  }

  @override
  void registerHandler(String actionType, QueueItemHandler handler) {
    _handlers[actionType] = handler;
  }

  @override
  Future<int> syncPendingQueue() async {
    try {
      final queue = await getPendingQueue();
      if (queue.isEmpty) return 0;

      int successCount = 0;
      for (final item in queue) {
        final handler = _handlers[item.actionType];
        if (handler != null) {
          try {
            final success = await handler(item);
            if (success) {
              await removeQueueItem(item.id);
              successCount++;
            } else {
              // Update retry count
              final box = queueBox;
              if (box != null) {
                await box.put(
                  item.id,
                  item.copyWith(retryCount: item.retryCount + 1).toMap(),
                );
              }
            }
          } catch (e) {
            debugPrint('Error syncing queue item ${item.id}: $e');
            final box = queueBox;
            if (box != null) {
              await box.put(
                item.id,
                item.copyWith(retryCount: item.retryCount + 1).toMap(),
              );
            }
          }
        } else {
          debugPrint('No handler registered for actionType: ${item.actionType}');
        }
      }
      return successCount;
    } catch (e) {
      debugPrint('Error during syncPendingQueue: $e');
      return 0;
    }
  }

  @override
  ValueListenable<Box>? listenToQueue() {
    return queueBox?.listenable();
  }
}
