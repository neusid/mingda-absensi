import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  /// Ikon representatif putih di dalam solid circle Gojek style
  IconData get icon {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return Icons.check_rounded;
      case WorkLeaveStatType.menunggu:
        return Icons.access_time_rounded;
      case WorkLeaveStatType.ditolak:
        return Icons.close_rounded;
      case WorkLeaveStatType.cutiTerpakai:
        return Icons.luggage_rounded;
    }
  }

  /// Warna solid cerah khas Gojek
  Color get accentColor {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return const Color(0xFF00AA13); // Gojek Green
      case WorkLeaveStatType.menunggu:
        return const Color(0xFFFF9800); // Gojek Amber
      case WorkLeaveStatType.ditolak:
        return const Color(0xFFED2736); // Gojek Red
      case WorkLeaveStatType.cutiTerpakai:
        return const Color(0xFF7C3AED); // Gojek Purple
    }
  }

  /// Background pastel lembut untuk kontainer squircle
  Color get containerBgColor {
    switch (this) {
      case WorkLeaveStatType.disetujui:
        return const Color(0xFFE6F7EB);
      case WorkLeaveStatType.menunggu:
        return const Color(0xFFFFF8E6);
      case WorkLeaveStatType.ditolak:
        return const Color(0xFFFEECEE);
      case WorkLeaveStatType.cutiTerpakai:
        return const Color(0xFFF2EBFD);
    }
  }

  Color get cardBorderColor {
    if (this == WorkLeaveStatType.ditolak) {
      return const Color(0xFFFECDD3);
    }
    return const Color(0xFFE2E8F0);
  }

  Color get labelColor {
    if (this == WorkLeaveStatType.ditolak) {
      return const Color(0xFFED2736);
    }
    return const Color(0xFF64748B);
  }
}

/// Widget Kartu Statistik Cuti (Product Design Standard — Gojek Solid Badge)
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
          // 1. Squircle Container dengan Lingkaran Solid Gojek Style di Tengah
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: type.containerBgColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Center(
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: type.accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    type.icon,
                    color: Colors.white,
                    size: 18.w,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? type.accentColor : type.cardBorderColor,
          width: isSelected ? 2.w : 1.2.w,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: type.accentColor.withValues(alpha: 0.20),
              blurRadius: 10.r,
              offset: Offset(0, 3.w),
            ),
          BoxShadow(
            color: const Color(0x0A0F172A), // Soft ambient shadow
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
