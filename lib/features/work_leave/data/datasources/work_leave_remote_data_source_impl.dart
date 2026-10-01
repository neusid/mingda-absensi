import 'package:dio/dio.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/work_leave/data/datasources/work_leave_remote_data_source.dart';
import 'package:mingda_app/features/work_leave/data/models/leave_item_model.dart';

class WorkLeaveRemoteDataSourceImpl implements WorkLeaveRemoteDataSource {
  final Dio dio;

  WorkLeaveRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<LeaveItemModel>> getLeaveList({
    int? month,
    int? year,
    String? status,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (month != null) queryParams['month'] = month;
      if (year != null) queryParams['year'] = year;
      if (status != null && status.isNotEmpty && status.toLowerCase() != 'semua status') {
        queryParams['status'] = status.toLowerCase();
      }

      final response = await dio.get(
        '/mobile/v1/leave',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final dynamic rawData = response.data;
      List<dynamic> itemsList = [];

      if (rawData is Map<String, dynamic>) {
        final nestedData = rawData['data'];
        if (nestedData is List) {
          itemsList = nestedData;
        } else if (nestedData is Map<String, dynamic> && nestedData['data'] is List) {
          itemsList = nestedData['data'] as List;
        }
      } else if (rawData is List) {
        itemsList = rawData;
      }

      return itemsList
          .whereType<Map<String, dynamic>>()
          .map((json) => LeaveItemModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final apiMessage = e.response?.data is Map
          ? (e.response?.data as Map)['message']?.toString()
          : null;

      if (statusCode == 401) {
        throw AuthFailure(
          apiMessage ?? 'Sesi telah berakhir, mohon login ulang.',
        );
      }

      throw ServerFailure(
        apiMessage ?? 'Terjadi kendala memuat data pengajuan cuti (Kode: $statusCode).',
      );
    } catch (e) {
      throw ServerFailure('Gagal memproses data pengajuan cuti: $e');
    }
  }
}
