import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  String get label {
    switch (this) {
      case AttendanceStatType.hadir:
        return 'TOTAL HADIR';
      case AttendanceStatType.terlambat:
        return 'TOTAL TERLAMBAT';
      case AttendanceStatType.alpha:
        return 'TOTAL ALPHA';
      case AttendanceStatType.izin:
        return 'TOTAL IZIN';
      case AttendanceStatType.cuti:
        return 'TOTAL CUTI';
      case AttendanceStatType.sakit:
        return 'TOTAL SAKIT';
    }
  }

  /// Path ke badge SVG 48x48 pixel-perfect dari Figma export
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

  /// Path ke kartu SVG lengkap dari folder Mingda Absensi (36)
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

  /// Warna solid cerah khas Figma Mingda Absensi (36)
  Color get accentColor {
    switch (this) {
      case AttendanceStatType.hadir:
        return const Color(0xFF00AA13);
      case AttendanceStatType.terlambat:
        return const Color(0xFFD97706);
      case AttendanceStatType.alpha:
        return const Color(0xFFED2736);
      case AttendanceStatType.izin:
        return const Color(0xFF0284C7);
      case AttendanceStatType.cuti:
        return const Color(0xFF4F46E5);
      case AttendanceStatType.sakit:
        return const Color(0xFF0D9488);
    }
  }

  /// Background pastel lembut untuk kontainer squircle
  Color get containerBgColor => const Color(0xFFF0FDFA);

  Color get cardBgColor => const Color(0xFFF0FDFA);

  Color get cardBorderColor => const Color(0xFFCCFBF1);

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

  /// Factory sampel data presensi bulanan persis dari screenshot Tuan
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

/// Widget Kartu Statistik Presensi (Figma SVG Template — Pixel Perfect Gojek Style)
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
          // 1. Symmetrical Squircle + Solid Circle Vector Badge
          SvgPicture.asset(
            type.svgBadgePath,
            width: 44.w,
            height: 44.w,
          ),
          SizedBox(width: 8.w),

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
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A), // Slate 900
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
                    fontSize: 9.8.sp,
                    fontWeight: FontWeight.w700,
                    color: type.labelColor,
                    letterSpacing: 0.2,
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

    return Container(
      height: 72.w,
      decoration: BoxDecoration(
        color: type.cardBgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: type.cardBorderColor,
          width: 1.2.w,
        ),
        boxShadow: [AppShadows.shadow094],
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16.r),
                splashColor: type.accentColor.withValues(alpha: 0.12),
                highlightColor: type.accentColor.withValues(alpha: 0.05),
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
