import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';

/// Tier 2 Loading: Shimmer Skeleton for Warning Letter Page.
///
/// Ditampilkan saat data SP sedang dalam tahap fetching / reload / filter.
class WarningLetterSkeleton extends StatelessWidget {
  const WarningLetterSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.w),
            // Banner Edukasi Skeleton
            SkeletonBox(
              width: double.infinity,
              height: 78.w,
              radius: 12.r,
            ),
            SizedBox(height: 14.w),
            // 2 Stat Card Atas
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 70.w, radius: 10.r)),
                SizedBox(width: 8.w),
                Expanded(child: SkeletonBox(height: 70.w, radius: 10.r)),
              ],
            ),
            SizedBox(height: 8.w),
            // 1 Stat Card Lebar
            SkeletonBox(
              width: double.infinity,
              height: 70.w,
              radius: 10.r,
            ),
            SizedBox(height: 15.w),
            // Filter Dropdown Row Skeleton
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 42.w, radius: 8.r)),
                SizedBox(width: 10.w),
                Expanded(child: SkeletonBox(height: 42.w, radius: 8.r)),
              ],
            ),
            SizedBox(height: 12.w),
            // Action Buttons Skeleton (Cari & Reset)
            SkeletonBox(
              width: double.infinity,
              height: 40.w,
              radius: 8.r,
            ),
            SizedBox(height: 16.w),
            // List Item Skeletons
            SkeletonBox(
              width: double.infinity,
              height: 130.w,
              radius: 12.r,
            ),
            SizedBox(height: 12.w),
            SkeletonBox(
              width: double.infinity,
              height: 130.w,
              radius: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}
