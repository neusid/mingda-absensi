import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/core/widgets/mingda_page_loading.dart';
import 'package:mingda_app/core/widgets/mingda_page_transition_wrapper.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_header_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isPageTransitioning = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isPageTransitioning = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content;
    // Tier 1: Initial mount / route transition
    if (_isPageTransitioning) {
      content = const KeyedSubtree(
        key: ValueKey('profile_loading'),
        child: Scaffold(
          backgroundColor: AppColors.bg,
          body: MingdaPageLoading(),
        ),
      );
    } else {
      content = KeyedSubtree(
        key: const ValueKey('profile_body'),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is! SuccessDashboardState) {
              return const _ProfileSkeleton();
            }
            return _ProfileContent(profile: state.profileEntity);
          },
        ),
      );
    }

    return MingdaPageTransitionWrapper(child: content);
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

              // Remake Header (sesuai profile_header_card_remake.svg)
              ProfileHeaderCard(
                profile: profile,
                onNotificationTap: () {},
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
              SizedBox(height: 19.w),

              _SettingItem(
                icon: Icons.person_outline_rounded,
                label: 'Ubah Informasi',
                onTap: () {},
              ),
              SizedBox(height: 10.w),
              _SettingItem(
                icon: Icons.lock_outline_rounded,
                label: 'Ubah Password',
                onTap: () {},
              ),
              SizedBox(height: 10.w),
              _SettingItem(
                icon: Icons.logout_rounded,
                label: 'Keluar',
                onTap: () {
                  context.read<DashboardBloc>().add(DashboardSignout());
                },
                isLogout: true,
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
    if (isLogout) {
      return Container(
        height: 54.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFFFECDD3),
            width: 1.2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            splashColor: const Color(0xFFFEF2F2),
            highlightColor: const Color(0xFFFEE2E2).withValues(alpha: 0.5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: const Color(0xFFFECDD3),
                        width: 1.2.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      icon,
                      size: 20.w,
                      color: const Color(0xFFED2736),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFDC2626),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.w,
                    color: const Color(0xFFFCA5A5),
                  ),
                  SizedBox(width: 4.w),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 54.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.45),
          width: 1.2.w,
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.filterGradientStart,
            AppColors.filterGradientEnd,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.40),
                      width: 1.2.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 20.w,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.w,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
                SizedBox(width: 4.w),
              ],
            ),
          ),
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
                // Header profil remake skeleton
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: Colors.white, width: 1.5.w),
                    boxShadow: const [AppShadows.shadow094],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SkeletonBox(width: 62.w, height: 62.w, radius: 18.r),
                      SizedBox(width: 14.w),
                      Expanded(
                        child: SizedBox(
                          height: 62.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SkeletonBox(width: 85.w, height: 11.w, radius: 4.r),
                              SkeletonBox(width: 125.w, height: 16.w, radius: 4.r),
                              SkeletonBox(width: 145.w, height: 23.w, radius: 11.5.r),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      SkeletonBox(width: 40.w, height: 40.w, radius: 13.r),
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
                SkeletonBox(width: double.infinity, height: 54.w, radius: 16.r),
                SizedBox(height: 10.w),
                SkeletonBox(width: double.infinity, height: 54.w, radius: 16.r),
                SizedBox(height: 10.w),
                SkeletonBox(width: double.infinity, height: 54.w, radius: 16.r),
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
