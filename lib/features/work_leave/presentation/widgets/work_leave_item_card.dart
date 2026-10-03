import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Kartu Riwayat Pengajuan Cuti & Izin (Corporate Teal & Micro-Badge Standards)
class WorkLeaveItemCard extends StatelessWidget {
  final String title;
  final String status;
  final String startDate;
  final String endDate;
  final VoidCallback? onTap;

  const WorkLeaveItemCard({
    super.key,
    required this.title,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.onTap,
  });

  /// Status badge dot color
  Color get _statusDotColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFF059669); // Emerald 600
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFDC2626); // Red 600
    } else {
      return const Color(0xFFD97706); // Amber 600
    }
  }

  /// Status badge background color
  Color get _statusBgColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFFE8FAF3); // Mint / Green 50
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFFEECEC); // Rose / Red 50
    } else {
      return const Color(0xFFFFFBEB); // Amber 50
    }
  }

  /// Status badge border color
  Color get _statusBorderColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFFA7F3D0); // Mint / Green 200
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFFECACA); // Rose / Red 200
    } else {
      return const Color(0xFFFDE68A); // Amber 200
    }
  }

  /// Status badge text color
  Color get _statusTextColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFF047857); // Green 700
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFB91C1C); // Red 700
    } else {
      return const Color(0xFFB45309); // Amber 700
    }
  }

  /// Icon semantik outline yang sesuai dengan jenis pengajuan
  IconData get _iconData {
    final lower = title.toLowerCase();
    if (lower.contains('sakit') || lower.contains('sick') || lower.contains('病')) {
      return Icons.medical_services_outlined;
    } else if (lower.contains('cuti') || lower.contains('leave') || lower.contains('annual') || lower.contains('假')) {
      return Icons.event_available_outlined;
    } else {
      return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.w),
          splashColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
          highlightColor: const Color(0xFF0D9488).withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Unified Corporate Teal Squircle
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA), // Frosted Soft Mint Teal
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: const Color(0xFFCCFBF1), // Soft Teal border
                      width: 1.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    _iconData,
                    size: 22.w,
                    color: const Color(0xFF0D9488), // Teal 600
                  ),
                ),
                SizedBox(width: 12.w),

                // 2. Konten Informasi & Micro-Badge Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Micro-Badge Status (sesuai aturan Master Knowledge)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.5.w,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBgColor,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: _statusBorderColor,
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
                                    color: _statusDotColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 2.5.w),
                                Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 8.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: _statusTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.w),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 12.w,
                            color: const Color(0xFF64748B),
                          ),
                          SizedBox(width: 5.w),
                          Flexible(
                            child: Text(
                              startDate,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 11.w,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              endDate,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
    );
  }
}

