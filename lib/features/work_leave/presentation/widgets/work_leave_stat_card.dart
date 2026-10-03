import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Jenis kategori statistik pengajuan cuti & izin
enum WorkLeaveStatType {
  disetujui,
  menunggu,
  ditolak,
  cutiTerpakai;

  String get label {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return 'DISETUJUI';
      case WorkLeaveStatType.menunggu:
        return 'MENUNGGU';
      case WorkLeaveStatType.ditolak:
        return 'DITOLAK';
      case WorkLeaveStatType.cutiTerpakai:
        return 'CUTI TERPAKAI';
    }
  }

  String getLocalizedLabel(BuildContext context) {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return context.tr.leaveStatApproved.toUpperCase();
      case WorkLeaveStatType.menunggu:
        return context.tr.leaveStatPending.toUpperCase();
      case WorkLeaveStatType.ditolak:
        return context.tr.leaveStatRejected.toUpperCase();
      case WorkLeaveStatType.cutiTerpakai:
        return context.tr.leaveStatUsed.toUpperCase();
    }
  }

  /// Ikon vektor monoline modern korporat
  IconData get icon {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return Icons.check_circle_outline_rounded;
      case WorkLeaveStatType.menunggu:
        return Icons.access_time_rounded;
      case WorkLeaveStatType.ditolak:
        return Icons.highlight_off_rounded;
      case WorkLeaveStatType.cutiTerpakai:
        return Icons.event_available_outlined;
    }
  }

  /// Warna aksen utama Teal Korporat terpadu
  Color get accentColor => const Color(0xFF0D9488); // Teal 600

  /// Background pastel Soft Mint Teal
  Color get containerBgColor => const Color(0xFFF0FDFA); // Mint 50

  /// Border halus Teal
  Color get borderColor => const Color(0xFFCCFBF1); // Mint / Teal 100

  Color get cardBgColor => Colors.white;

  Color get cardBorderColor => const Color(0xFFE2E8F0);

  Color get labelColor => const Color(0xFF64748B);
}

/// Widget Kartu Statistik Cuti (Corporate Teal — 100% Selaras Brand Mingda)
class WorkLeaveStatCard extends StatelessWidget {
  final WorkLeaveStatType type;
  final String value;
  final bool isSelected;
  final VoidCallback? onTap;

  const WorkLeaveStatCard({
    super.key,
    required this.type,
    required this.value,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Corporate Teal Squircle + Clean Vector Outline Icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF0F766E) // Deep Teal saat aktif
                  : const Color(0xFFF0FDFA), // Soft Mint Teal
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0F766E)
                    : const Color(0xFFCCFBF1),
                width: 1.2.w,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              type.icon,
              size: 22.w,
              color: isSelected ? Colors.white : const Color(0xFF0D9488),
            ),
          ),
          SizedBox(width: 9.w),

          // 2. Value & Label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF0F766E)
                        : AppColors.textPrimary,
                    letterSpacing: -0.5,
                    height: 1.1,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  type.getLocalizedLabel(context),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9.8.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      constraints: BoxConstraints(minHeight: 72.w),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: isSelected
            ? Border.all(
                color: const Color(0xFF0D9488),
                width: 1.5.w,
              )
            : null,
        boxShadow: isSelected
            ? [
                const BoxShadow(
                  color: Color(0x180F766E),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
            : [AppShadows.shadow094],
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(10.w),
                splashColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
                highlightColor: const Color(0xFF0D9488).withValues(alpha: 0.05),
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }
}

