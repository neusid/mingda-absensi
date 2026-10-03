import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/work_leave/domain/entities/leave_item_entity.dart';

/// Modal Bottom Sheet untuk melihat detail riwayat pengajuan cuti / izin
class WorkLeaveDetailSheet extends StatelessWidget {
  final LeaveItemEntity item;

  const WorkLeaveDetailSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, LeaveItemEntity item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => WorkLeaveDetailSheet(item: item),
    );
  }

  Color get _statusDotColor {
    final lower = item.status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFF059669);
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFDC2626);
    } else {
      return const Color(0xFFD97706);
    }
  }

  Color get _statusBgColor {
    final lower = item.status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFFE8FAF3);
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFFEECEC);
    } else {
      return const Color(0xFFFFFBEB);
    }
  }

  Color get _statusTextColor {
    final lower = item.status.toLowerCase();
    if (lower.contains('setuju') || lower.contains('approved') || lower.contains('批准')) {
      return const Color(0xFF047857);
    } else if (lower.contains('tolak') || lower.contains('rejected') || lower.contains('驳回')) {
      return const Color(0xFFB91C1C);
    } else {
      return const Color(0xFFB45309);
    }
  }

  int get _durationDays {
    final start = DateTime.tryParse(item.startDate);
    final end = DateTime.tryParse(item.endDate);
    if (start != null && end != null) {
      final diff = end.difference(start).inDays + 1;
      return diff > 0 ? diff : 1;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(18.w, 12.w, 18.w, 24.w),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
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
            SizedBox(height: 14.w),

            // Header & Status Badge
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.localizedTitle(context.currentLanguage),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        '${context.tr.applicationId}: #${item.id}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                  decoration: BoxDecoration(
                    color: _statusBgColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: _statusDotColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: _statusDotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        item.localizedStatus(context.currentLanguage),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: _statusTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.w),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            SizedBox(height: 14.w),

            // Info Grid / Cards
            _buildDetailRow(
              icon: Icons.calendar_today_rounded,
              label: context.tr.applicationPeriod,
              value:
                  '${item.startDate} ${context.tr.toWord} ${item.endDate} ($_durationDays ${context.tr.daysSuffix})',
            ),
            SizedBox(height: 12.w),
            _buildDetailRow(
              icon: Icons.category_outlined,
              label: context.tr.leaveTypeLabel,
              value: item.localizedTitle(context.currentLanguage).toUpperCase(),
            ),
            SizedBox(height: 12.w),
            _buildDetailRow(
              icon: Icons.notes_rounded,
              label: context.tr.reasonLabel,
              value: item.localizedReason(context.currentLanguage).isNotEmpty
                  ? item.localizedReason(context.currentLanguage)
                  : '-',
            ),
            if (item.attachment != null && item.attachment!.isNotEmpty) ...[
              SizedBox(height: 12.w),
              _buildDetailRow(
                icon: Icons.attach_file_rounded,
                label: context.tr.attachmentLabel,
                value: item.attachment!,
                isAttachment: true,
              ),
            ],

            SizedBox(height: 20.w),

            // Tombol Tutup
            SizedBox(
              width: double.infinity,
              height: 42.w,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                ),
                child: Text(
                  context.tr.close,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isAttachment = false,
  }) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.w, color: const Color(0xFF0D9488)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isAttachment ? const Color(0xFF0F766E) : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
