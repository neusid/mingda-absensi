import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';

/// Skeleton loading untuk halaman dashboard — meniru layout asli
/// (header profil, tanggal, 4 kartu statistik, dan list aktivitas).
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.bg,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 58.w),
        child: SkeletonLoading(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar + nama + notifikasi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SkeletonBox(width: 50.w, height: 50.w, radius: 10.w),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(width: 100.w, height: 14.w),
                          SizedBox(height: 8.w),
                          SkeletonBox(width: 160.w, height: 16.w),
                        ],
                      ),
                    ],
                  ),
                  SkeletonBox(width: 40.w, height: 40.w, radius: 10.w),
                ],
              ),
              SizedBox(height: 22.w),

              // Tanggal + chip posisi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonBox(width: 140.w, height: 20.w),
                  SkeletonBox(width: 120.w, height: 26.w, radius: 10.w),
                ],
              ),
              SizedBox(height: 17.w),

              // 4 kartu statistik
              SkeletonBox(width: double.infinity, height: 126.w, radius: 10.w),
              SizedBox(height: 15.w),
              SkeletonBox(width: double.infinity, height: 126.w, radius: 10.w),
              SizedBox(height: 17.w),

              // Bar "Your activity"
              SkeletonBox(width: double.infinity, height: 40.w, radius: 5.w),
              SizedBox(height: 17.w),

              // List aktivitas
              SkeletonBox(width: double.infinity, height: 120.w, radius: 10.w),
              SizedBox(height: 10.w),
              SkeletonBox(width: double.infinity, height: 120.w, radius: 10.w),
              SizedBox(height: 10.w),
              SkeletonBox(width: double.infinity, height: 120.w, radius: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}
