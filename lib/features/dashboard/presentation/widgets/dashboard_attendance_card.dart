import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';

enum DashboardAttendanceType { masuk, pulang, other }

class DashboardAttendanceItem {
  final DashboardAttendanceType type;
  final String title;
  final String statusText;
  final bool isLate;
  final int lateMinutes;
  final String dateText;
  final String timeText;
  final String method;
  final bool isToday;
  final AttendanceItemEntity attendance;

  const DashboardAttendanceItem({
    required this.type,
    required this.title,
    required this.statusText,
    required this.isLate,
    this.lateMinutes = 0,
    required this.dateText,
    required this.timeText,
    this.method = 'Via Fingerprint',
    this.isToday = false,
    required this.attendance,
  });

  /// Ekstraksi item absensi harian menjadi deretan kartu aktivitas masuk/pulang.
  /// Event untuk hari ini (today) ditandai dengan [isToday] = true agar menggunakan
  /// kartu teal gradient (attendance_card_today_teal).
  static List<DashboardAttendanceItem> fromAttendanceList(
    List<AttendanceItemEntity> list, {
    int? limit,
    bool treatLatestAsToday = true,
    AppLanguage language = AppLanguage.id,
  }) {
    final items = <DashboardAttendanceItem>[];
    final now = DateTime.now();
    final String latestDateInList =
        list.isNotEmpty ? list.first.attendanceDate : '';

    // Translation helpers
    final String pulangTitle = switch (language) {
      AppLanguage.en => 'Check Out',
      AppLanguage.zh => '下班打卡',
      AppLanguage.id => 'Pulang',
    };
    final String masukTitle = switch (language) {
      AppLanguage.en => 'Check In',
      AppLanguage.zh => '上班打卡',
      AppLanguage.id => 'Masuk',
    };
    final String onTimeText = switch (language) {
      AppLanguage.en => 'On Time',
      AppLanguage.zh => '准时',
      AppLanguage.id => 'Tepat Waktu',
    };
    final String methodText = switch (language) {
      AppLanguage.en => 'Via Fingerprint',
      AppLanguage.zh => '指纹考勤',
      AppLanguage.id => 'Via Fingerprint',
    };

    for (final att in list) {
      // Tandai sebagai 'today' jika tanggal sesuai hari ini atau tanggal entri terbaru (bila treatLatestAsToday = true)
      final bool isToday = _isSameDay(att.attendanceDate, now) ||
          (treatLatestAsToday && att.attendanceDate == latestDateInList);

      // 1. Event Pulang (Check-out) ditampilkan lebih atas jika ada
      if (att.checkOut != null && att.checkOut!.trim().isNotEmpty) {
        items.add(
          DashboardAttendanceItem(
            type: DashboardAttendanceType.pulang,
            title: pulangTitle,
            statusText: onTimeText,
            isLate: false,
            dateText: _formatDate(att.attendanceDate, language),
            timeText: _formatTime(att.checkOut!),
            method: methodText,
            isToday: isToday,
            attendance: att,
          ),
        );
        if (limit != null && items.length >= limit) break;
      }

      // 2. Event Masuk (Check-in)
      if (att.checkIn != null && att.checkIn!.trim().isNotEmpty) {
        final isLate =
            att.lateMinutes > 0 || att.status.toLowerCase() == 'terlambat';
        final String lateText = switch (language) {
          AppLanguage.en => att.lateMinutes > 0
              ? 'Late (${att.lateMinutes}m)'
              : 'Late',
          AppLanguage.zh => att.lateMinutes > 0
              ? '迟到 (${att.lateMinutes}分)'
              : '迟到',
          AppLanguage.id => att.lateMinutes > 0
              ? 'Terlambat (${att.lateMinutes}m)'
              : 'Terlambat',
        };

        items.add(
          DashboardAttendanceItem(
            type: DashboardAttendanceType.masuk,
            title: masukTitle,
            statusText: isLate ? lateText : onTimeText,
            isLate: isLate,
            lateMinutes: att.lateMinutes,
            dateText: _formatDate(att.attendanceDate, language),
            timeText: _formatTime(att.checkIn!),
            method: methodText,
            isToday: isToday,
            attendance: att,
          ),
        );
        if (limit != null && items.length >= limit) break;
      }

      // 3. Fallback izin / sakit / cuti tanpa jam masuk & pulang
      if ((att.checkIn == null || att.checkIn!.trim().isEmpty) &&
          (att.checkOut == null || att.checkOut!.trim().isEmpty)) {
        final statusTitle = att.status.isNotEmpty
            ? '${att.status[0].toUpperCase()}${att.status.substring(1)}'
            : 'Absensi';
        items.add(
          DashboardAttendanceItem(
            type: DashboardAttendanceType.other,
            title: statusTitle,
            statusText: att.status.toUpperCase(),
            isLate: false,
            dateText: _formatDate(att.attendanceDate, language),
            timeText: '--:--',
            method: language == AppLanguage.zh ? '申请' : (language == AppLanguage.en ? 'Submission' : 'Pengajuan'),
            isToday: isToday,
            attendance: att,
          ),
        );
        if (limit != null && items.length >= limit) break;
      }
    }

    if (limit != null) {
      return items.take(limit).toList();
    }
    return items;
  }

  static String _formatDate(String dateStr, [AppLanguage language = AppLanguage.id]) {
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return dateStr;
    switch (language) {
      case AppLanguage.en:
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
      case AppLanguage.zh:
        return '${dt.year}年${dt.month}月${dt.day}日';
      case AppLanguage.id:
        const months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
        ];
        return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    }
  }

  static String _formatTime(String timeStr) {
    final clean = timeStr.trim();
    final parts = clean.split(':');
    if (parts.length < 2) return timeStr;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return timeStr;

    final String period = hour >= 12 ? 'pm' : 'am';
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;

    final hourStr = hour12.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');

    return '$hourStr:$minuteStr $period';
  }

  static bool _isSameDay(String dateStr, DateTime target) {
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return false;
    return dt.year == target.year &&
        dt.month == target.month &&
        dt.day == target.day;
  }
}

class DashboardAttendanceCard extends StatelessWidget {
  final DashboardAttendanceItem item;
  final VoidCallback? onTap;

  const DashboardAttendanceCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isToday = item.isToday;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.w),
        canRequestFocus: false,
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
          decoration: isToday
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F766E), // Teal 700 dari attendance_card_today_teal
                      Color(0xFF14B8A6), // Teal 500
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x200F766E),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [AppShadows.shadow094],
                  color: AppColors.white,
                ),
          child: Row(
            children: [
              // 1. Icon Container
              _buildLeadingIcon(isToday),
              SizedBox(width: 12.w),

              // 2. Center Column: Title + Badge & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            item.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16.w,
                              fontWeight: FontWeight.w600,
                              color: isToday
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: _buildStatusBadge(isToday),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.w),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/calendar.svg',
                          width: 13.w,
                          height: 13.w,
                          colorFilter: ColorFilter.mode(
                            isToday
                                ? Colors.white.withValues(alpha: 0.85)
                                : const Color(0xFF64748B),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Flexible(
                          child: Text(
                            item.dateText,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.w,
                              fontWeight: FontWeight.w400,
                              color: isToday
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Right Column: Time & Method
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.timeText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.w,
                      fontWeight: FontWeight.w600,
                      color: isToday
                          ? Colors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 5.w),
                  Text(
                    item.method,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.w,
                      fontWeight: FontWeight.w500,
                      color: isToday
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(bool isToday) {
    if (isToday) {
      Widget iconWidget;
      if (item.type == DashboardAttendanceType.pulang) {
        iconWidget = SvgPicture.asset(
          'assets/icon/logout.svg',
          width: 22.w,
          height: 22.w,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        );
      } else if (item.isLate) {
        iconWidget = Icon(
          Icons.access_time_rounded,
          size: 24.w,
          color: Colors.white,
        );
      } else if (item.type == DashboardAttendanceType.masuk) {
        iconWidget = SvgPicture.asset(
          'assets/icon/login.svg',
          width: 22.w,
          height: 22.w,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        );
      } else {
        iconWidget = SvgPicture.asset(
          'assets/icon/calendar.svg',
          width: 20.w,
          height: 20.w,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        );
      }

      return Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.55),
            width: 1.2.w,
          ),
        ),
        alignment: Alignment.center,
        child: iconWidget,
      );
    }

    // Non-today cards: Unified Corporate Teal (anti-warna-warni)
    Widget iconWidget;
    const tealIconColor = Color(0xFF0D9488); // Teal 600

    if (item.type == DashboardAttendanceType.pulang) {
      iconWidget = SvgPicture.asset(
        'assets/icon/logout.svg',
        width: 22.w,
        height: 22.w,
        colorFilter: const ColorFilter.mode(
          tealIconColor,
          BlendMode.srcIn,
        ),
      );
    } else if (item.isLate) {
      iconWidget = Icon(
        Icons.access_time_rounded,
        size: 24.w,
        color: tealIconColor,
      );
    } else if (item.type == DashboardAttendanceType.masuk) {
      iconWidget = SvgPicture.asset(
        'assets/icon/login.svg',
        width: 22.w,
        height: 22.w,
        colorFilter: const ColorFilter.mode(
          tealIconColor,
          BlendMode.srcIn,
        ),
      );
    } else {
      iconWidget = SvgPicture.asset(
        'assets/icon/calendar.svg',
        width: 20.w,
        height: 20.w,
        colorFilter: const ColorFilter.mode(
          tealIconColor,
          BlendMode.srcIn,
        ),
      );
    }

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDFA), // Frosted Soft Mint Teal
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFCCFBF1), // Soft Teal border
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: iconWidget,
    );
  }

  Widget _buildStatusBadge(bool isToday) {
    if (isToday) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.45),
            width: 0.8.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: item.isLate
                    ? const Color(0xFFF87171)
                    : const Color(0xFF34D399),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 2.5.w),
            Flexible(
              child: Text(
                item.statusText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Color bgColor;
    Color borderColor;
    Color dotColor;
    Color textColor;

    if (item.type == DashboardAttendanceType.pulang) {
      bgColor = const Color(0xFFE0F2FE);
      borderColor = const Color(0xFFBAE6FD);
      dotColor = const Color(0xFF0284C7);
      textColor = const Color(0xFF0284C7);
    } else if (item.isLate) {
      bgColor = const Color(0xFFFEECEC);
      borderColor = const Color(0xFFFECACA);
      dotColor = const Color(0xFFDC2626);
      textColor = const Color(0xFFB91C1C);
    } else if (item.type == DashboardAttendanceType.masuk) {
      bgColor = const Color(0xFFE8FAF3);
      borderColor = const Color(0xFFA7F3D0);
      dotColor = const Color(0xFF059669);
      textColor = const Color(0xFF047857);
    } else {
      bgColor = const Color(0xFFF1F5F9);
      borderColor = const Color(0xFFE2E8F0);
      dotColor = const Color(0xFF64748B);
      textColor = const Color(0xFF475569);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 0.8.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 3.w,
            height: 3.w,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.5.w),
          Flexible(
            child: Text(
              item.statusText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
