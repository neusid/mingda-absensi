import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class WorkLeavePage extends StatelessWidget {
  const WorkLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.w),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.calendar_today,
                            iconColor: AppColors.green2,
                            iconBg: AppColors.green250,
                            value: '12',
                            label: 'DISETUJUI',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.calendar_month,
                            iconColor: AppColors.yellow2,
                            iconBg: AppColors.yellow250,
                            value: '5',
                            label: 'MENUNGGU',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.event_busy,
                            iconColor: AppColors.red,
                            iconBg: AppColors.red50,
                            value: '1',
                            label: 'DITOLAK',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.edit_calendar,
                            iconColor: AppColors.charcoalSlate,
                            iconBg: AppColors.charcoalSlate50,
                            value: '2',
                            label: 'CUTI TERPAKAI',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.w),

                    // Filter
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _FilterDropdown(value: 'Desember'),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 1,
                          child: _FilterDropdown(value: '2014'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.w),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _FilterDropdown(value: 'Semua Status'),
                        ),
                        SizedBox(width: 8.w),
                        _FilterIconButton(icon: Icons.sort),
                        SizedBox(width: 8.w),
                        _FilterIconButton(icon: Icons.delete_outline),
                      ],
                    ),
                    SizedBox(height: 20.w),

                    // Header Riwayat
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 9.w,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Riwayat Pengajuan Cuti',
                              style: AppTextStyles.inter14MediumPrimary,
                            ),
                          ),
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              color: AppColors.deepTeal,
                              borderRadius: BorderRadius.circular(5.w),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20.w,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.w),

                    // List riwayat
                    _LeaveItem(
                      iconBg: AppColors.deepTeal50,
                      iconColor: AppColors.deepTeal,
                      title: 'Izin Sakit',
                      status: 'Disetujui',
                      statusColor: AppColors.green2,
                      date: '10 Apr 2026',
                    ),
                    SizedBox(height: 10.w),
                    _LeaveItem(
                      iconBg: AppColors.deepTeal50,
                      iconColor: AppColors.deepTeal,
                      title: 'Izin Sakit',
                      status: 'Ditolak',
                      statusColor: AppColors.orange,
                      date: '10 Apr 2026',
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.w),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            borderRadius: BorderRadius.circular(8.w),
            child: Icon(Icons.close, size: 24.w, color: AppColors.textPrimary),
          ),
          SizedBox(width: 12.w),
          Text(
            'Back To Dashboard',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
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
                fontFamily: 'Inter',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
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

class _FilterIconButton extends StatelessWidget {
  final IconData icon;

  const _FilterIconButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.w,
      height: 45.w,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Icon(icon, size: 24.w, color: AppColors.textPrimary),
    );
  }
}

class _LeaveItem extends StatelessWidget {
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String status;
  final Color statusColor;
  final String date;

  const _LeaveItem({
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        children: [
          Container(
            width: 55.w,
            height: 55.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Icon(Icons.calendar_month, size: 24.w, color: iconColor),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.inter16MediumPrimary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.w,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(5.w),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Lexend Deca',
                          fontSize: 9.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.w),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 18.w,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      date,
                      style: AppTextStyles.inter10RegularWhite.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 15.w,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      date,
                      style: AppTextStyles.inter10RegularWhite.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
