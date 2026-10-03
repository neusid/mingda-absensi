import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.message,
    required super.category,
    required super.type,
    required super.createdAt,
    super.isRead,
    super.actionUrl,
    super.metadata,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Parse category
    final categoryStr = json['category']?.toString().toLowerCase() ?? 'announcement';
    NotificationCategory category;
    if (categoryStr == 'activity' || categoryStr == 'aktivitas') {
      category = NotificationCategory.activity;
    } else {
      category = NotificationCategory.announcement;
    }

    // Parse type
    final typeStr = json['type']?.toString().toLowerCase() ?? 'announcement';
    NotificationType type;
    switch (typeStr) {
      case 'leave_approval':
      case 'leaveapproval':
        type = NotificationType.leaveApproval;
        break;
      case 'leave_rejection':
      case 'leaverejection':
        type = NotificationType.leaveRejection;
        break;
      case 'attendance_reminder':
      case 'attendancereminder':
        type = NotificationType.attendanceReminder;
        break;
      case 'payslip_released':
      case 'payslipreleased':
        type = NotificationType.payslipReleased;
        break;
      case 'warning_letter':
      case 'warningletter':
        type = NotificationType.warningLetter;
        break;
      default:
        type = NotificationType.announcement;
    }

    // Parse createdAt
    DateTime parsedDate;
    if (json['created_at'] != null) {
      parsedDate = DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    // Parse isRead
    final isRead = json['is_read'] == true ||
        json['is_read'] == 1 ||
        json['read_at'] != null;

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? json['content']?.toString() ?? '',
      category: category,
      type: type,
      createdAt: parsedDate,
      isRead: isRead,
      actionUrl: json['action_url']?.toString(),
      metadata: json['metadata'] is Map<String, dynamic>
          ? json['metadata'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'category': category.name,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'action_url': actionUrl,
      'metadata': metadata,
    };
  }

  NotificationEntity toDomain() => this;
}
