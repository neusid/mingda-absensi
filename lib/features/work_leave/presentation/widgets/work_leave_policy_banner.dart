import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Banner Edukasi & Regulasi Cuti Karyawan
/// Memadukan foto background resmi dengan Dual-Layer Scrim Gradient Mingda
class WorkLeavePolicyBanner extends StatelessWidget {
  final VoidCallback onTap;

  const WorkLeavePolicyBanner({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          AppShadows.shadow094,
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.16),
            offset: const Offset(0, 4),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.w),
        child: Stack(
          children: [
            // ─── 1. Background Image ───
            Positioned.fill(
              child: Image.asset(
                'assets/img/warning_letter_banner.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),

            // ─── 2. Horizontal Scrim Overlay (Dark Slate Left -> Translucent Right) ───
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: const [0.0, 0.58, 1.0],
                    colors: [
                      const Color(0xFF0F172A).withValues(alpha: 0.94),
                      const Color(0xFF0F766E).withValues(alpha: 0.68),
                      Colors.black.withValues(alpha: 0.22),
                    ],
                  ),
                ),
              ),
            ),

            // ─── 3. Subtle Bottom Vignette ───
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.55, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.45),
                    ],
                  ),
                ),
              ),
            ),

            // ─── 4. Border Halus Mingda ───
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                      width: 1.5.w,
                    ),
                  ),
                ),
              ),
            ),

            // ─── 5. Foreground Content ───
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12.w),
                splashColor: Colors.white.withValues(alpha: 0.12),
                highlightColor: Colors.white.withValues(alpha: 0.06),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tag Kategori
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 3.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(6.w),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.35),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.event_note_rounded,
                                  size: 11.w,
                                  color: const Color(0xFF5EEAD4),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'REGULASI & KEBIJAKAN CUTI',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.info_outline_rounded,
                            size: 16.w,
                            color: Colors.white.withValues(alpha: 0.70),
                          ),
                        ],
                      ),

                      SizedBox(height: 10.w),

                      // Title
                      Text(
                        'Pedoman & Regulasi Pengajuan Cuti',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),

                      SizedBox(height: 4.w),

                      // Description
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 240.w),
                        child: Text(
                          'Hak cuti tahunan, cuti khusus & batas pengajuan izin.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.88),
                            height: 1.35,
                          ),
                        ),
                      ),

                      SizedBox(height: 12.w),

                      // Action Link Button
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.5.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6.w),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Baca SOP Cuti & Izin',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 12.w,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
