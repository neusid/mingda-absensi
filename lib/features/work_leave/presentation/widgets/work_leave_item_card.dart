import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Kartu Riwayat Pengajuan Cuti & Izin (Product Design Standard)
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

  Color get _statusBgColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju')) {
      return const Color(0xFFE6F7EB);
    } else if (lower.contains('tolak')) {
      return const Color(0xFFFEECEE);
    } else {
      return const Color(0xFFFFF8E6);
    }
  }

  Color get _statusTextColor {
    final lower = status.toLowerCase();
    if (lower.contains('setuju')) {
      return const Color(0xFF00AA13);
    } else if (lower.contains('tolak')) {
      return const Color(0xFFED2736);
    } else {
      return const Color(0xFFD97706);
    }
  }

  Color get _iconAccentColor {
    final lower = title.toLowerCase();
    if (lower.contains('sakit')) {
      return const Color(0xFFFF5722);
    } else if (lower.contains('cuti')) {
      return const Color(0xFF7C3AED);
    } else {
      return const Color(0xFF00AED6);
    }
  }

  Color get _iconBgColor {
    final lower = title.toLowerCase();
    if (lower.contains('sakit')) {
      return const Color(0xFFFEEFEA);
    } else if (lower.contains('cuti')) {
      return const Color(0xFFF2EBFD);
    } else {
      return const Color(0xFFE6F7FB);
    }
  }

  IconData get _iconData {
    final lower = title.toLowerCase();
    if (lower.contains('sakit')) {
      return Icons.add_rounded;
    } else if (lower.contains('cuti')) {
      return Icons.luggage_rounded;
    } else {
      return Icons.description_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A0F172A),
            blurRadius: 14.r,
            offset: Offset(0, 4.w),
          ),
          BoxShadow(
            color: const Color(0x050F172A),
            blurRadius: 3.r,
            offset: Offset(0, 1.w),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: _iconAccentColor.withValues(alpha: 0.12),
          highlightColor: _iconAccentColor.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Squircle Badge Gojek-Style
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: _iconBgColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Center(
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        color: _iconAccentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          _iconData,
                          size: 18.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // 2. Konten Informasi & Pill Status
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
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.w,
                            ),
                            decoration: BoxDecoration(
                              color: _statusBgColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: _statusTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.w),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 13.w,
                            color: const Color(0xFF64748B),
                          ),
                          SizedBox(width: 4.w),
                          Flexible(
                            child: Text(
                              startDate,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                                fontSize: 10.5.sp,
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
