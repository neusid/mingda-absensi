import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/localization/app_language.dart';

enum NotificationCategory {
  all,
  announcement,
  activity,
}

enum NotificationType {
  announcement,
  leaveApproval,
  leaveRejection,
  attendanceReminder,
  payslipReleased,
  warningLetter,
}

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationCategory category;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic>? metadata;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.actionUrl,
    this.metadata,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    NotificationCategory? category,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      category: category ?? this.category,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  String localizedTitle(AppLanguage lang) {
    if (lang == AppLanguage.id) return title;
    switch (id) {
      case 'notif-1':
        return lang == AppLanguage.zh
            ? '全国法定假日及联合休假通告'
            : 'National Holiday & Collective Leave Circular';
      case 'notif-2':
        return lang == AppLanguage.zh
            ? '年假申请已获得批准'
            : 'Annual Leave Application Approved';
      case 'notif-3':
        return lang == AppLanguage.zh
            ? '人脸生物识别考勤升级通知'
            : 'Facial Biometric Attendance Upgrade Briefing';
      case 'notif-4':
        return lang == AppLanguage.zh
            ? '2026年9月份工资单已生成'
            : 'September 2026 Payslip Has Been Released';
      case 'notif-5':
        return lang == AppLanguage.zh
            ? '早班工作打卡签退提醒'
            : 'Morning Shift Check-Out Reminder';
      default:
        if (title.contains('Libur')) {
          return lang == AppLanguage.zh ? '法定节假日放假通知' : 'Holiday Notification';
        }
        if (title.contains('Disetujui')) {
          return lang == AppLanguage.zh ? '申请已批准' : 'Request Approved';
        }
        if (title.contains('Ditolak')) {
          return lang == AppLanguage.zh ? '申请已驳回' : 'Request Rejected';
        }
        if (title.contains('Slip Gaji')) {
          return lang == AppLanguage.zh ? '工资单已生成' : 'Payslip Released';
        }
        if (title.contains('Presensi') || title.contains('Check-Out')) {
          return lang == AppLanguage.zh ? '考勤签退提醒' : 'Attendance Reminder';
        }
        return title;
    }
  }

  String localizedMessage(AppLanguage lang) {
    if (lang == AppLanguage.id) return message;
    switch (id) {
      case 'notif-1':
        return lang == AppLanguage.zh
            ? '特此通知 PT Mingda 全体员工，因全国法定假日及联合休假安排，公司暂停相关运营活动。请确保所有交接工作井然有序完成。'
            : 'All employees of PT Mingda are hereby informed that operational activities are suspended for National Holidays & Collective Leave. Please ensure all handovers are completed properly.';
      case 'notif-2':
        return lang == AppLanguage.zh
            ? '恭喜，您于2026年10月12日至10月14日（3个工作日）的年假申请已获得部门主管及人事部门批准。'
            : 'Congratulations, your Annual Leave application for October 12-14, 2026 (3 working days) has been approved by Division Manager and HRD.';
      case 'notif-3':
        return lang == AppLanguage.zh
            ? '自2026年11月1日起，Mingda移动打卡系统将引入新一代活体人脸识别技术，以全面提升考勤准确性。'
            : 'Effective November 1, 2026, the Mingda mobile attendance system will introduce next-generation facial biometric liveness detection to enhance attendance data accuracy.';
      case 'notif-4':
        return lang == AppLanguage.zh
            ? '您2026年9月份的正式工资单已由财务部核算完成，现已可在应用程序中查看或下载。'
            : 'Your official payslip for September 2026 has been processed by Finance and is ready for review or download in the app.';
      case 'notif-5':
        return lang == AppLanguage.zh
            ? '您的早班工作时间已于 17:00 结束。请务必在已核准的工作地点及时完成每日考勤签退。'
            : 'Your morning shift ends at 17:00. Please ensure you perform your daily attendance check-out on time at a verified workplace.';
      default:
        return message;
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        category,
        type,
        createdAt,
        isRead,
        actionUrl,
        metadata,
      ];
}
