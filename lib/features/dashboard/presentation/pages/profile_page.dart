import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_network_image.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is! SuccessDashboardState) {
          return const _ProfileSkeleton();
        }
        return _ProfileContent(profile: state.profileEntity);
      },
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final ProfileEntity profile;

  const _ProfileContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.w),

              // Header: avatar, nama, email chip, notifikasi
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Row(
                  children: [
                    ProfileNetworkImage(
                      url: profile.profilePhotoUrl,
                      width: 70.w,
                      height: 70.w,
                      radius: 10.w,
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.inter16MediumPrimary,
                          ),
                          SizedBox(height: 10.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 2.w,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepTeal,
                              borderRadius: BorderRadius.circular(9.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 15.w,
                                  height: 15.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    size: 10.w,
                                    color: AppColors.deepTeal,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Flexible(
                                  child: Text(
                                    profile.email,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.inter96RegularWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Icon(
                        Icons.notifications_outlined,
                        size: 22.w,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 19.w),

              // Grid 2x2 info
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.qr_code,
                      label: 'Kode',
                      value: profile.employeeCode,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.business_outlined,
                      label: 'Department',
                      value: profile.department.name,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.work_outline,
                      label: 'Jabatan',
                      value: profile.position.displayName,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.call_outlined,
                      label: 'Phone',
                      value: profile.phone,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 19.w),

              // Header section "Pengaturan Akun"
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 9.w),
                  child: Text(
                    'Pengaturan Akun',
                    style: AppTextStyles.inter14MediumPrimary,
                  ),
                ),
              ),
              SizedBox(height: 10.w),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15.w),
                ),
                child: Column(
                  children: [
                    _SettingItem(
                      icon: Icons.edit_outlined,
                      label: 'Ubah Informasi',
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 60.w,
                      color: AppColors.gray.withValues(alpha: 0.3),
                    ),
                    _SettingItem(
                      icon: Icons.edit_outlined,
                      label: 'Ubah Password',
                      onTap: () {},
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 60.w,
                      color: AppColors.gray.withValues(alpha: 0.3),
                    ),
                    _SettingItem(
                      icon: Icons.logout,
                      label: 'Keluar',
                      onTap: () {
                        context.read<DashboardBloc>().add(DashboardSignout());
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppColors.charcoalSlate50,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Icon(icon, size: 18.w, color: AppColors.textPrimary),
          ),
          SizedBox(height: 7.w),
          Text(
            label,
            style: AppTextStyles.inter96MediumSecondary,
          ),
          SizedBox(height: 2.w),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.inter14MediumPrimary,
          ),
        ],
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.w),
        child: Row(
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppColors.charcoalSlate50,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Icon(
                icon,
                size: 18.w,
                color: isLogout ? AppColors.red : AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.inter14MediumPrimary,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.w,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SkeletonLoading(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.w),
                // Header profil
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Row(
                    children: [
                      SkeletonBox(width: 70.w, height: 70.w, radius: 10.w),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBox(width: 140.w, height: 16.w),
                            SizedBox(height: 10.w),
                            SkeletonBox(width: 180.w, height: 26.w, radius: 9.w),
                          ],
                        ),
                      ),
                      SkeletonBox(width: 40.w, height: 40.w, radius: 10.w),
                    ],
                  ),
                ),
                SizedBox(height: 19.w),
                // Grid info
                Row(
                  children: [
                    Expanded(child: _skeletonInfoCard()),
                    SizedBox(width: 10.w),
                    Expanded(child: _skeletonInfoCard()),
                  ],
                ),
                SizedBox(height: 10.w),
                Row(
                  children: [
                    Expanded(child: _skeletonInfoCard()),
                    SizedBox(width: 10.w),
                    Expanded(child: _skeletonInfoCard()),
                  ],
                ),
                SizedBox(height: 19.w),
                // Section pengaturan
                SkeletonBox(width: double.infinity, height: 40.w, radius: 5.w),
                SizedBox(height: 10.w),
                SkeletonBox(width: double.infinity, height: 164.w, radius: 15.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _skeletonInfoCard() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 30.w, height: 30.w, radius: 5.w),
          SizedBox(height: 7.w),
          SkeletonBox(width: 60.w, height: 12.w),
          SizedBox(height: 2.w),
          SkeletonBox(width: 90.w, height: 14.w),
        ],
      ),
    );
  }
}
