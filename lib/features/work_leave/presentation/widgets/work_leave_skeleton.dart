import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';

class WorkLeaveSkeleton extends StatelessWidget {
  const WorkLeaveSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.w),
            // 4 Stat Cards Skeleton
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 72.w, radius: 16.r)),
                SizedBox(width: 10.w),
                Expanded(child: SkeletonBox(height: 72.w, radius: 16.r)),
              ],
            ),
            SizedBox(height: 10.w),
            Row(
              children: [
                Expanded(child: SkeletonBox(height: 72.w, radius: 16.r)),
                SizedBox(width: 10.w),
                Expanded(child: SkeletonBox(height: 72.w, radius: 16.r)),
              ],
            ),
            SizedBox(height: 18.w),
            // Filter Skeleton
            SkeletonBox(height: 44.w, radius: 12.r),
            SizedBox(height: 20.w),
            // Header Skeleton
            SkeletonBox(height: 48.w, radius: 12.r),
            SizedBox(height: 12.w),
            // Item Skeletons
            SkeletonBox(height: 74.w, radius: 16.r),
            SizedBox(height: 10.w),
            SkeletonBox(height: 74.w, radius: 16.r),
          ],
        ),
      ),
    );
  }
}
