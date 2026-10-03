import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';

/// Kartu Notifikasi Mengadopsi:
/// 1. Clean Solid Surface with Crisp White Border (Standar Mingda Absensi)
/// 2. Unified Corporate Teal Squircle Icon (Anti-Rainbow Invariant, Dominan Teal)
/// 3. Zero-Overflow & Unclipped Hierarchy (Label Pengumuman & Kategori Utuh Tanpa Terpotong)
class NotificationItemCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationItemCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getNotificationTypeConfig(context, notification.type);
    final lang = context.currentLanguage;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: Colors.white,
          width: 1.5.w,
        ),
        boxShadow: [AppShadows.shadow094],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.w),
        child: Stack(
          children: [
            // Left Unread Accent Indicator Bar
            if (!notification.isRead)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 3.5.w,
                child: Container(
                  color: AppColors.filterTealAccent,
                ),
              ),

            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                splashColor: const Color(0xFF0D9488).withValues(alpha: 0.08),
                highlightColor: const Color(0xFF0D9488).withValues(alpha: 0.03),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Unified Corporate Teal Squircle Icon (Anti-Rainbow standard)
                      Container(
                        width: 42.w,
                        height: 42.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0FDFA), // Soft Mint Teal
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(
                            color: const Color(0xFFCCFBF1), // Soft Mint border
                            width: 1.w,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          config.icon,
                          size: 21.w,
                          color: const Color(0xFF0D9488), // Mingda Corporate Teal 600
                        ),
                      ),

                      SizedBox(width: 12.w),

                      // Konten Notifikasi
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Baris 1: Kategori Tag (Utuh Mandiri, Tidak Pernah Terpotong)
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 7.w,
                                    vertical: 2.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(4.w),
                                    border: Border.all(
                                      color: const Color(0xFFCCFBF1),
                                      width: 0.8.w,
                                    ),
                                  ),
                                  child: Text(
                                    config.tagLabel,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F766E),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                if (!notification.isRead) ...[
                                  SizedBox(width: 6.w),
                                  Container(
                                    width: 6.w,
                                    height: 6.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.filterTealAccent,
                                    ),
                                  ),
                                ],
                              ],
                            ),

                            SizedBox(height: 5.w),

                            // Baris 2: Judul Notifikasi
                            Text(
                              notification.localizedTitle(lang),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.5.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700,
                                color: notification.isRead
                                    ? const Color(0xFF334155)
                                    : const Color(0xFF0F172A),
                                letterSpacing: -0.2,
                                height: 1.3,
                              ),
                            ),

                            SizedBox(height: 3.w),

                            // Baris 3: Ringkasan Pesan Notifikasi
                            Text(
                              notification.localizedMessage(lang),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                                height: 1.38,
                              ),
                            ),

                            SizedBox(height: 6.w),

                            // Baris 4: Metadata Bar (Waktu & Chevron Navigasi)
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 11.5.w,
                                  color: const Color(0xFF94A3B8),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _formatTimestamp(context, notification.createdAt),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 16.w,
                                  color: const Color(0xFFCBD5E1),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return context.tr.notifJustNow;
    } else if (difference.inMinutes < 60) {
      return context.tr.notifMinAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return context.tr.notifHoursAgo(difference.inHours);
    } else if (difference.inDays == 1) {
      return context.tr.yesterday;
    } else if (difference.inDays < 7) {
      return context.tr.notifDaysAgo(difference.inDays);
    } else {
      return dateTime.toLocalizedShortDate(context.currentLanguage);
    }
  }

  _NotificationTypeConfig _getNotificationTypeConfig(
    BuildContext context,
    NotificationType type,
  ) {
    switch (type) {
      case NotificationType.announcement:
        return _NotificationTypeConfig(
          icon: Icons.campaign_rounded,
          tagLabel: context.tr.notifTagAnnouncement,
        );
      case NotificationType.leaveApproval:
        return _NotificationTypeConfig(
          icon: Icons.check_circle_rounded,
          tagLabel: context.tr.notifTagLeaveApproved,
        );
      case NotificationType.leaveRejection:
        return _NotificationTypeConfig(
          icon: Icons.highlight_off_rounded,
          tagLabel: context.tr.notifTagLeaveRejected,
        );
      case NotificationType.attendanceReminder:
        return _NotificationTypeConfig(
          icon: Icons.alarm_rounded,
          tagLabel: context.tr.notifTagAttendance,
        );
      case NotificationType.payslipReleased:
        return _NotificationTypeConfig(
          icon: Icons.receipt_long_rounded,
          tagLabel: context.tr.notifTagPayslip,
        );
      case NotificationType.warningLetter:
        return _NotificationTypeConfig(
          icon: Icons.warning_amber_rounded,
          tagLabel: context.tr.notifTagWarning,
        );
    }
  }
}

class _NotificationTypeConfig {
  final IconData icon;
  final String tagLabel;

  const _NotificationTypeConfig({
    required this.icon,
    required this.tagLabel,
  });
}
