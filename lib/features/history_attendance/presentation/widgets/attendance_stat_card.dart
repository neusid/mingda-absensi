import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';

/// Jenis kategori statistik presensi
enum AttendanceStatType {
  hadir,
  terlambat,
  alpha,
  izin,
  cuti,
  sakit;

  /// Label ringkas & jelas (bebas text overflow pada layar sempit)
  String get label {
    switch (this) {
      case AttendanceStatType.hadir:
        return 'HADIR';
      case AttendanceStatType.terlambat:
        return 'TERLAMBAT';
      case AttendanceStatType.alpha:
        return 'ALPHA';
      case AttendanceStatType.izin:
        return 'IZIN';
      case AttendanceStatType.cuti:
        return 'CUTI';
      case AttendanceStatType.sakit:
        return 'SAKIT';
    }
  }

  /// Ikon vektor monoline modern korporat
  IconData get iconData {
    switch (this) {
      case AttendanceStatType.hadir:
        return Icons.check_circle_outline_rounded;
      case AttendanceStatType.terlambat:
        return Icons.access_time_rounded;
      case AttendanceStatType.alpha:
        return Icons.highlight_off_rounded;
      case AttendanceStatType.izin:
        return Icons.description_outlined;
      case AttendanceStatType.cuti:
        return Icons.event_available_outlined;
      case AttendanceStatType.sakit:
        return Icons.medical_services_outlined;
    }
  }

  /// Warna aksen utama Teal Korporat terpadu (selaras dengan brand Mingda & dropdown)
  Color get accentColor => const Color(0xFF0D9488); // Teal 600

  /// Warna kontainer squircle: Frosted Soft Mint Teal
  Color get containerBgColor => const Color(0xFFF0FDFA); // Mint 50

  /// Border kontainer squircle: Teal halus
  Color get borderColor => const Color(0xFFCCFBF1); // Mint / Teal 100

  /// Pemetaan langsung ke domain AttendanceEnum untuk filter riwayat
  AttendanceEnum get toAttendanceEnum {
    switch (this) {
      case AttendanceStatType.hadir:
        return AttendanceEnum.Hadir;
      case AttendanceStatType.terlambat:
        return AttendanceEnum.Terlambat;
      case AttendanceStatType.alpha:
        return AttendanceEnum.Alpha;
      case AttendanceStatType.izin:
        return AttendanceEnum.Izin;
      case AttendanceStatType.cuti:
        return AttendanceEnum.Cuti;
      case AttendanceStatType.sakit:
        return AttendanceEnum.Sakit;
    }
  }

  /// Path ke badge SVG (fallback backwards compatibility)
  String get svgBadgePath {
    switch (this) {
      case AttendanceStatType.hadir:
        return 'assets/icon/stat_badge_hadir.svg';
      case AttendanceStatType.terlambat:
        return 'assets/icon/stat_badge_terlambat.svg';
      case AttendanceStatType.alpha:
        return 'assets/icon/stat_badge_alpha.svg';
      case AttendanceStatType.izin:
        return 'assets/icon/stat_badge_izin.svg';
      case AttendanceStatType.cuti:
        return 'assets/icon/stat_badge_cuti.svg';
      case AttendanceStatType.sakit:
        return 'assets/icon/stat_badge_sakit.svg';
    }
  }

  /// Path ke kartu SVG lengkap (fallback backwards compatibility)
  String get svgCardPath {
    switch (this) {
      case AttendanceStatType.hadir:
        return 'assets/icon/stat_card_hadir.svg';
      case AttendanceStatType.terlambat:
        return 'assets/icon/stat_card_terlambat.svg';
      case AttendanceStatType.alpha:
        return 'assets/icon/stat_card_alpha.svg';
      case AttendanceStatType.izin:
        return 'assets/icon/stat_card_izin.svg';
      case AttendanceStatType.cuti:
        return 'assets/icon/stat_card_cuti.svg';
      case AttendanceStatType.sakit:
        return 'assets/icon/stat_card_sakit.svg';
    }
  }

  Color get cardBgColor => AppColors.white;

  Color get cardBorderColor => Colors.transparent;

  Color get labelColor => const Color(0xFF64748B);
}

/// Data model item statistik
class AttendanceStatItem {
  final AttendanceStatType type;
  final int count;

  const AttendanceStatItem({
    required this.type,
    required this.count,
  });

  /// Factory sampel data presensi bulanan
  static List<AttendanceStatItem> sampleList() {
    return const [
      AttendanceStatItem(type: AttendanceStatType.hadir, count: 20),
      AttendanceStatItem(type: AttendanceStatType.terlambat, count: 0),
      AttendanceStatItem(type: AttendanceStatType.alpha, count: 0),
      AttendanceStatItem(type: AttendanceStatType.izin, count: 0),
      AttendanceStatItem(type: AttendanceStatType.cuti, count: 0),
      AttendanceStatItem(type: AttendanceStatType.sakit, count: 1),
    ];
  }
}

/// Widget Kartu Statistik Presensi (Corporate Teal — 100% Monokromatik & Selaras Brand)
class AttendanceStatCard extends StatelessWidget {
  final AttendanceStatType type;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;

  AttendanceStatCard({
    super.key,
    AttendanceStatType? type,
    int? count,
    AttendanceStatItem? item,
    this.isSelected = false,
    this.onTap,
  })  : assert(
          (type != null && count != null) || item != null,
          'Either (type and count) or item must be provided',
        ),
        type = type ?? item!.type,
        count = count ?? item!.count;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Corporate Teal Squircle + Clean Vector Icon
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
              type.iconData,
              size: 22.w,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF0D9488), // Teal 600
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
                  '$count',
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
                  type.label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.sp,
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
      height: 72.w,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF0FDFA) : AppColors.white,
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

/// Grid 2 Kolom untuk menampilkan seluruh rekap statistik
class AttendanceSummaryGrid extends StatelessWidget {
  final List<AttendanceStatItem> items;
  final AttendanceStatType? selectedType;
  final ValueChanged<AttendanceStatItem>? onItemTap;

  const AttendanceSummaryGrid({
    super.key,
    required this.items,
    this.selectedType,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
        childAspectRatio: 2.18,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return AttendanceStatCard(
          item: item,
          isSelected: selectedType == item.type,
          onTap: () => onItemTap?.call(item),
        );
      },
    );
  }
}
