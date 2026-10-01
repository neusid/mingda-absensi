import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';

class HistoryAttendanceItemCard extends StatelessWidget {
  final AttendanceItemEntity attendance;
  final bool isLatest;
  final VoidCallback? onTap;

  const HistoryAttendanceItemCard({
    super.key,
    required this.attendance,
    this.isLatest = false,
    this.onTap,
  });

  String _formatDate(String dateStr) {
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return dateStr;
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Color _getStatusBgColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return AppColors.green250;
      case 'terlambat':
        return AppColors.yellow250;
      case 'alpha':
        return AppColors.red50;
      case 'izin':
        return AppColors.deepTeal50;
      case 'cuti':
        return const Color(0xFFEDE7F6);
      case 'sakit':
        return const Color(0xFFFFECB3);
      case 'libur':
      default:
        return AppColors.charcoalSlate50;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return AppColors.green2;
      case 'terlambat':
        return const Color(0xFFB78103);
      case 'alpha':
        return AppColors.red;
      case 'izin':
        return AppColors.deepTeal;
      case 'cuti':
        return const Color(0xFF673AB7);
      case 'sakit':
        return const Color(0xFFE65100);
      case 'libur':
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBgColor = _getStatusBgColor(attendance.status);
    final statusTextColor = _getStatusTextColor(attendance.status);
    final isHadir = attendance.status.toLowerCase() == 'hadir';
    final hasLate = attendance.lateMinutes > 0;
    final hasOvertime = attendance.overtimeMinutes > 0;
    final hasSuspiciousGps =
        attendance.isMockedIn || attendance.isSuspiciousIn;
    final hasNotes =
        attendance.notes != null && attendance.notes!.trim().isNotEmpty;
    final hasLocationIn =
        attendance.locationIn != null &&
        attendance.locationIn!.trim().isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.w),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            boxShadow: [AppShadows.shadow094],
            color: AppColors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Header: Date + Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icon/calendar.svg',
                          width: 15.w,
                          height: 15.w,
                          colorFilter: const ColorFilter.mode(
                            AppColors.deepTeal,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            _formatDate(attendance.attendanceDate),
                            style: AppTextStyles.inter13MediumPrimary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLatest) ...[
                          SizedBox(width: 6.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepTeal50,
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Text(
                              'Terbaru',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepTeal,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.w,
                    ),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    child: Text(
                      attendance.status.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: statusTextColor,
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                height: 16.w,
                thickness: 0.8.w,
                color: const Color(0xFFEFF2F5),
              ),

              // 2. Times: Jam Masuk & Jam Keluar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(color: const Color(0xFFEAEFF5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: AppColors.deepTeal50,
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icon/login.svg',
                                width: 16.w,
                                height: 16.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.deepTeal,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Masuk',
                                  style: AppTextStyles.inter11RegularSecondary,
                                ),
                                Text(
                                  attendance.checkIn ?? '--:--',
                                  style: AppTextStyles.inter14MediumPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.w,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(color: const Color(0xFFEAEFF5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE8),
                              borderRadius: BorderRadius.circular(6.w),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icon/logout.svg',
                                width: 16.w,
                                height: 16.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.orange,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Keluar',
                                  style: AppTextStyles.inter11RegularSecondary,
                                ),
                                Text(
                                  attendance.checkOut ?? '--:--',
                                  style: AppTextStyles.inter14MediumPrimary,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 3. Detail Chips: Late / On-time / Overtime / GPS Suspicious
              if (hasLate ||
                  (isHadir && !hasLate) ||
                  hasOvertime ||
                  hasSuspiciousGps) ...[
                SizedBox(height: 8.w),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.w,
                  children: [
                    if (hasLate)
                      _buildChip(
                        label: 'Terlambat ${attendance.lateMinutes} mnt',
                        bgColor: const Color(0xFFFFF3E0),
                        borderColor: const Color(0xFFFFCC80),
                        textColor: const Color(0xFFD84315),
                        icon: Icons.timer_outlined,
                      ),
                    if (isHadir && !hasLate)
                      _buildChip(
                        label: 'Tepat Waktu',
                        bgColor: AppColors.green250,
                        borderColor: const Color(0xFFA5D6A7),
                        textColor: AppColors.green2,
                        icon: Icons.check_circle_outline,
                      ),
                    if (hasOvertime)
                      _buildChip(
                        label: 'Lembur ${attendance.overtimeMinutes} mnt',
                        bgColor: AppColors.deepTeal50,
                        borderColor: const Color(0xFFB2DFDB),
                        textColor: AppColors.deepTeal,
                        icon: Icons.more_time_outlined,
                      ),
                    if (hasSuspiciousGps)
                      _buildChip(
                        label: 'GPS Mencurigakan',
                        bgColor: AppColors.red50,
                        borderColor: const Color(0xFFFFCDD2),
                        textColor: AppColors.red,
                        icon: Icons.warning_amber_rounded,
                      ),
                  ],
                ),
              ],

              // 4. Detail Info: Location & Notes
              if (hasLocationIn || hasNotes) ...[
                SizedBox(height: 8.w),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFC),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasLocationIn)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.w),
                              child: SvgPicture.asset(
                                'assets/icon/building.svg',
                                width: 12.w,
                                height: 12.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.textSecondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                attendance.locationIn!,
                                style: AppTextStyles.inter11RegularSecondary,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      if (hasLocationIn && hasNotes) SizedBox(height: 4.w),
                      if (hasNotes)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 2.w),
                              child: SvgPicture.asset(
                                'assets/icon/note-add.svg',
                                width: 12.w,
                                height: 12.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.textSecondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                attendance.notes!,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],

              // 5. Footer: Tap to view full detail
              SizedBox(height: 8.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Lihat Detail Absensi',
                    style: AppTextStyles.inter12MediumDeepTeal,
                  ),
                  SizedBox(width: 4.w),
                  SvgPicture.asset(
                    'assets/icon/arrow-right.svg',
                    width: 12.w,
                    height: 12.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.deepTeal,
                      BlendMode.srcIn,
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

  Widget _buildChip({
    required String label,
    required Color bgColor,
    required Color borderColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: borderColor, width: 0.8.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: textColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
