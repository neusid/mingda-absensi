import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

class NotificationEmptyState extends StatelessWidget {
  final String? title;
  final String? description;

  const NotificationEmptyState({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? context.tr.noNotificationsYet;
    final displayDesc = description ?? context.tr.noNotificationsDesc;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Unified Corporate Teal Squircle (Mingda Anti-Rainbow standard)
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: const Color(0xFFCCFBF1),
                  width: 1.5.w,
                ),
                boxShadow: [AppShadows.shadow094],
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.notifications_none_rounded,
                size: 34.w,
                color: const Color(0xFF0D9488),
              ),
            ),

            SizedBox(height: 18.w),

            Text(
              displayTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
                letterSpacing: -0.3,
              ),
            ),

            SizedBox(height: 6.w),

            Text(
              displayDesc,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
