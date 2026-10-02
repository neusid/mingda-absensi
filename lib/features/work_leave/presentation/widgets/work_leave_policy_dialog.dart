import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Modal Float Dialog Pedoman & Regulasi Cuti & Izin (Peraturan PT Mingda)
/// Tampil mengambang di tengah layar (floating modal dialog) dengan animasi halus
class WorkLeavePolicyDialog extends StatelessWidget {
  const WorkLeavePolicyDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tutup Dialog',
      barrierColor: Colors.black.withValues(alpha: 0.50),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (ctx, anim1, anim2) => const WorkLeavePolicyDialog(),
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
                        color: AppColors.deepTeal50,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.deepTeal.withValues(alpha: 0.25),
                          width: 1.w,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.event_available_rounded,
                          color: AppColors.deepTeal,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedoman & Regulasi Cuti',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2.w),
                          Text(
                            'SOP & Ketentuan Resmi PT Mingda',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.sp,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 20,
                      color: const Color(0xFF94A3B8),
                      splashRadius: 20,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

              // ─── Content List ───
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.w),
                  child: Column(
                    children: [
                      _buildPolicyItem(
                        badgeColor: AppColors.deepTeal50,
                        badgeTextColor: AppColors.deepTeal,
                        category: 'CUTI TAHUNAN',
                        title: 'Hak 12 Hari Kerja per Tahun',
                        desc:
                            'Diberikan kepada karyawan yang telah memiliki masa kerja minimal 12 bulan secara terus-menerus. Pengajuan wajib disubmit minimal H-3 sebelum hari H cuti.',
                      ),
                      SizedBox(height: 12.w),
                      _buildPolicyItem(
                        badgeColor: const Color(0xFFEFF6FF),
                        badgeTextColor: const Color(0xFF2563EB),
                        category: 'CUTI SAKIT & MEDIS',
                        title: 'Surat Keterangan Dokter Resmi',
                        desc:
                            'Karyawan yang berhalangan hadir karena sakit wajib mengunggah Surat Keterangan Dokter (SKD) resmi yang mencantumkan masa istirahat dan diagnosis klinis.',
                      ),
                      SizedBox(height: 12.w),
                      _buildPolicyItem(
                        badgeColor: const Color(0xFFFEF3C7),
                        badgeTextColor: const Color(0xFFD97706),
                        category: 'IZIN KHUSUS / DISPENSASI',
                        title: 'Ketentuan Pernikahan & Duka Cita',
                        desc:
                            'Pernikahan karyawan (3 hari), pernikahan anak kandung (2 hari), khitanan/baptis anak (2 hari), duka cita anggota keluarga inti (2 hari kerja berturut-turut).',
                      ),
                      SizedBox(height: 12.w),
                      _buildPolicyItem(
                        badgeColor: const Color(0xFFF1F5F9),
                        badgeTextColor: const Color(0xFF475569),
                        category: 'PROSEDUR APPROVAL',
                        title: 'Hierarki Persetujuan Bertingkat',
                        desc:
                            'Setiap permohonan yang disubmit akan diverifikasi oleh Atasan Langsung (SPV/Manager) sebelum diproses final oleh Tim HRD & Personalia.',
                      ),
                    ],
                  ),
                ),
              ),

              const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

              // ─── Footer Action: Saya Mengerti (Mingda Gradient) ───
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.w),
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
                          'Saya Mengerti',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.sp,
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

  Widget _buildPolicyItem({
    required Color badgeColor,
    required Color badgeTextColor,
    required String category,
    required String title,
    required String desc,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: badgeTextColor,
                letterSpacing: 0.4,
              ),
            ),
          ),
          SizedBox(height: 6.w),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            desc,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
