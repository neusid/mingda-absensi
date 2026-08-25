import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';

/// Skeleton loading untuk halaman history attendance.
class HistorySkeleton extends StatelessWidget {
  const HistorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.w),
      child: SkeletonLoading(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter bulan/tahun/status
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 45.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 45.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 45.w),
                ),
              ],
            ),
            SizedBox(height: 20.w),

            // 4 kartu statistik
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 100.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 100.w),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 100.w),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SkeletonBox(width: double.infinity, height: 100.w),
                ),
              ],
            ),
            SizedBox(height: 20.w),

            // List item
            SkeletonBox(width: double.infinity, height: 100.w),
            SizedBox(height: 10.w),
            SkeletonBox(width: double.infinity, height: 100.w),
            SizedBox(height: 10.w),
            SkeletonBox(width: double.infinity, height: 100.w),
          ],
        ),
      ),
    );
  }
}
