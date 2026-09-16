import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class WarningLetterPage extends StatelessWidget {
  const WarningLetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.w),

                    // 2 kartu statistik atas
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.event_busy,
                            iconColor: AppColors.red,
                            iconBg: AppColors.red50,
                            value: '1',
                            label: 'SP AKTIF',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.calendar_today,
                            iconColor: AppColors.green2,
                            iconBg: AppColors.green250,
                            value: '12',
                            label: 'SP SELESAI',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),

                    // 1 kartu statistik lebar
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(11.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: AppColors.charcoalSlate50,
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: Icon(
                              Icons.edit_calendar,
                              size: 24.w,
                              color: AppColors.charcoalSlate,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '2',
                                style: AppTextStyles.inter16MediumPrimary,
                              ),
                              Text(
                                'TOTAL SP DITERIMA',
                                style: AppTextStyles.inter8MediumSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 15.w),

                    // Filter: dropdown jenis & status
                    Row(
                      children: [
                        Expanded(child: _FilterDropdown(value: 'Pilih jenis')),
                        SizedBox(width: 7.w),
                        Expanded(child: _FilterDropdown(value: 'Pilih Status')),
                      ],
                    ),
                    SizedBox(height: 10.w),

                    // Tombol Cari & Reset
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: 'Cari',
                            icon: Icons.search,
                            backgroundColor: AppColors.deepTeal,
                            foregroundColor: AppColors.white,
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _ActionButton(
                            label: 'Reset',
                            icon: Icons.refresh,
                            backgroundColor: AppColors.white,
                            foregroundColor: AppColors.textSecondary,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.w),

                    // List surat peringatan
                    const _WarningCard(
                      code: 'SP-1',
                      title: 'Keterlambatan',
                      status: 'Aktif',
                      isActive: true,
                      date: 'Diterbitkan: 10 Jan 2026',
                      description:
                          'Terlambat 3x berturut-turut dalam seminggu. '
                          'Perlu penagihan kedisiplinan.',
                    ),
                    SizedBox(height: 12.w),
                    const _WarningCard(
                      code: 'SP-2',
                      title: 'Pelanggaran SOP',
                      status: 'Aktif',
                      isActive: true,
                      date: 'Diterbitkan: 02 Apr 2026',
                      description:
                          'Tidak mengikuti prosedur K3 pada shift malam. '
                          'Perlu pelatihan ulang.',
                    ),
                    SizedBox(height: 12.w),
                    const _WarningCard(
                      code: 'SP-1',
                      title: 'Absensi',
                      status: 'Selesai',
                      isActive: false,
                      date: 'Diterbitkan: 25 Feb 2026',
                      description:
                          'Tidak hadir tanpa keterangan selama 2 hari. '
                          'Sudah ditindaklanjuti.',
                    ),
                    SizedBox(height: 12.w),
                    const _WarningCard(
                      code: 'SP-3',
                      title: 'Disiplin',
                      status: 'Aktif',
                      isActive: true,
                      date: 'Diterbitkan: 01 Jun 2026',
                      description:
                          'Pelanggaran aturan seragam kerja. '
                          'Perlu evaluasi kedisiplinan.',
                    ),

                    SizedBox(height: 24.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Icon(icon, size: 24.w, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.inter16MediumPrimary),
              Text(label, style: AppTextStyles.inter8MediumSecondary),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;

  const _FilterDropdown({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xFF8B8B8B),
              ),
            ),
          ),
          Icon(Icons.keyboard_arrow_down, size: 24.w, color: Color(0xFF8B8B8B)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.w),
      child: Container(
        height: 34.w,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14.w, color: foregroundColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  final String code;
  final String title;
  final String status;
  final bool isActive;
  final String date;
  final String description;

  const _WarningCard({
    required this.code,
    required this.title,
    required this.status,
    required this.isActive,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isActive ? AppColors.green2 : Color(0xFF7F7F7F);
    final Color statusBg = isActive ? AppColors.green250 : Color(0xFFF3F4F6);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                decoration: BoxDecoration(
                  color: AppColors.deepTeal50,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Text(
                  code,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepTeal,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.charcoalSlate,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.w),
          Text(
            date,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            description,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
