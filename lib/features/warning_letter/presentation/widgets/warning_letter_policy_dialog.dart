import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Modal Float Dialog Pedoman & Regulasi Surat Peringatan (PP PT Mingda)
/// Tampil mengambang di tengah layar (floating modal dialog) dengan animasi halus
class WarningLetterPolicyDialog extends StatelessWidget {
  const WarningLetterPolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.50),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim1, anim2) => const WarningLetterPolicyDialog(),
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curvedValue = Curves.easeOutCubic.transform(anim.value);
        return Transform.scale(
          scale: 0.94 + (0.06 * curvedValue),
          child: Opacity(
            opacity: anim.value,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
      child: Container(
        constraints: BoxConstraints(maxWidth: 380.w, maxHeight: 600.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.w),
          border: Border.all(color: Colors.white, width: 1.5.w),
          boxShadow: [
            AppShadows.shadow094,
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.14),
              offset: const Offset(0, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Header: Icon + Title + Close Button ───
              Padding(
                padding: EdgeInsets.fromLTRB(18.w, 16.w, 12.w, 12.w),
                child: Row(
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: const Color(0xFFCCFBF1),
                          width: 1.w,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 20.w,
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.warningPolicyDialogTitle,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoalSlate,
                            ),
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            context.tr.spRegulationsSubtitle,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.r),
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: EdgeInsets.all(6.w),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20.w,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFFF1F5F9), height: 1),

              // ─── Content Scrollable ───
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 14.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPolicySection(
                        step: '1',
                        title: context.tr.spSection1Title,
                        content: context.tr.spSection1Content,
                      ),
                      SizedBox(height: 10.w),
                      _buildPolicySection(
                        step: '2',
                        title: context.tr.spSection2Title,
                        content: context.tr.spSection2Content,
                      ),
                      SizedBox(height: 10.w),
                      _buildPolicySection(
                        step: '3',
                        title: context.tr.spSection3Title,
                        content: context.tr.spSection3Content,
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(color: Color(0xFFF1F5F9), height: 1),

              // ─── Bottom CTA: Saya Mengerti ───
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Container(
                  width: double.infinity,
                  height: 42.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF0F766E), // Mingda Deep Teal
                        Color(0xFF14B8A6), // Mingda Accent Teal
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.w),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.45),
                      width: 1.5.w,
                    ),
                    boxShadow: [AppShadows.shadow094],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.w),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Text(
                          context.tr.iUnderstand,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicySection({
    required String step,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: const BoxDecoration(
              color: Color(0xFF0F766E),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              step,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoalSlate,
                  ),
                ),
                SizedBox(height: 4.w),
                Text(
                  content,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF475569),
                    height: 1.45,
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
