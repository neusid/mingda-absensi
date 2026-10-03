import 'package:dio/dio.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:mingda_app/features/notification/data/models/notification_model.dart';

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dio.get('/mobile/v1/announcements');
      if (response.statusCode == 200 && response.data != null) {
        final dynamic rawData = response.data['data'];
        if (rawData is List) {
          return rawData
              .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Gagal memuat notifikasi');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dio.get('/mobile/v1/announcements/unread-count');
      if (response.statusCode == 200 && response.data != null) {
        final count = response.data['data']?['unread_count'] ?? response.data['count'];
        if (count is num) {
          return count.toInt();
        }
      }
      return 0;
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Gagal mengambil unread count');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await dio.post('/mobile/v1/announcements/$id/mark-read');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Gagal menandai notifikasi dibaca');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dio.post('/mobile/v1/announcements/mark-all-read');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Gagal menandai semua notifikasi dibaca');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
