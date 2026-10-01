import 'package:equatable/equatable.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';

class LeaveItemModel extends Equatable {
  final int id;
  final int? employeeId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String? attachment;
  final String? createdAt;
  final String? updatedAt;

  const LeaveItemModel({
    required this.id,
    this.employeeId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.attachment,
    this.createdAt,
    this.updatedAt,
  });

  factory LeaveItemModel.fromJson(Map<String, dynamic> json) {
    return LeaveItemModel(
      id: _toInt(json['id']) ?? 0,
      employeeId: _toInt(json['employee_id']),
      leaveType: json['leave_type']?.toString() ?? json['type']?.toString() ?? 'cuti',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      reason: json['reason']?.toString() ?? json['keterangan']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      attachment: json['attachment']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'status': status,
      'attachment': attachment,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  /// Mapper wajib toDomain()
  LeaveItemEntity toDomain() {
    return LeaveItemEntity(
      id: id,
      employeeId: employeeId,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: status,
      attachment: attachment,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeId,
        leaveType,
        startDate,
        endDate,
        reason,
        status,
        attachment,
        createdAt,
        updatedAt,
      ];
}
