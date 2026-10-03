import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/notification/domain/entities/notification_entity.dart';

class NotificationDetailSheet extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailSheet({
    super.key,
    required this.notification,
  });

  static Future<void> show(
    BuildContext context,
    NotificationEntity notification,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDetailSheet(notification: notification),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.currentLanguage;
    final timeStr = DateFormat('HH:mm').format(notification.createdAt);
    final formattedDate =
        '${notification.createdAt.toLocalizedShortDate(lang)} • $timeStr';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.w),
              // Top Drag Handle Bar
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),

              SizedBox(height: 16.w),

              // Header Row: Category Badge & Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFCCFBF1),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          notification.category == NotificationCategory.announcement
                              ? Icons.campaign_rounded
                              : Icons.person_rounded,
                          size: 15.w,
                          color: AppColors.filterTealAccent,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          notification.category == NotificationCategory.announcement
                              ? context.tr.officialAnnouncementBadge
                              : context.tr.employeeActivityBadge,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F766E),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20.w,
                      color: const Color(0xFF64748B),
                    ),
                    splashRadius: 18.w,
                  ),
                ],
              ),

              SizedBox(height: 12.w),

              // Title
              Text(
                notification.localizedTitle(lang),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                  height: 1.3,
                ),
              ),

              SizedBox(height: 6.w),

              // Timestamp & Sender
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 13.w,
                    color: const Color(0xFF94A3B8),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Text(
                      formattedDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5.sp,
                        color: const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 14.w),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              SizedBox(height: 14.w),

              // Full Message Content
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 280.h),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.localizedMessage(lang),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          color: const Color(0xFF334155),
                          height: 1.55,
                        ),
                      ),
                      if (notification.metadata != null &&
                          notification.metadata!.isNotEmpty) ...[
                        SizedBox(height: 16.w),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1.w,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: notification.metadata!.entries.map((entry) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: Text(
                                        entry.key.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      ': ',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10.sp,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        entry.value.toString(),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.w),

              // Action Buttons
              Row(
                children: [
                  if (notification.actionUrl != null) ...[
                    Expanded(
                      child: Container(
                        height: 46.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.filterGradientStart,
                              AppColors.filterGradientEnd,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D9488).withValues(alpha: 0.28),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: () {
                              Navigator.pop(context);
                              if (notification.actionUrl != null) {
                                Navigator.pushNamed(context, notification.actionUrl!);
                              }
                            },
                            child: Center(
                              child: Text(
                                context.tr.openRelatedPage,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                  ],
                  Expanded(
                    child: Container(
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: notification.actionUrl == null
                            ? AppColors.filterTealAccent
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: Text(
                              notification.actionUrl == null
                                  ? context.tr.understood
                                  : context.tr.close,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: notification.actionUrl == null
                                    ? Colors.white
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.w),
            ],
          ),
        ),
      ),
    );
  }
}
