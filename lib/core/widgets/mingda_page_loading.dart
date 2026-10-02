import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';

/// Tier 1 Loading: Page Transition / Initial Mount Loading.
///
/// Digunakan saat awal build, navigasi antar halaman, atau initial state
/// sebelum fetching data dimulai. Menggunakan spinner minimalis elegan
/// Corporate Teal (#0D9488) yang terpusat.
class MingdaPageLoading extends StatelessWidget {
  final Color? backgroundColor;
  final Color? spinnerColor;
  final double? size;
  final double? strokeWidth;
  final String? message;

  const MingdaPageLoading({
    super.key,
    this.backgroundColor,
    this.spinnerColor,
    this.size,
    this.strokeWidth,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.bg,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 32.w,
            height: size ?? 32.w,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth ?? 3.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                spinnerColor ?? AppColors.filterTealAccent,
              ),
            ),
          ),
          if (message != null && message!.isNotEmpty) ...[
            SizedBox(height: 12.w),
            Text(
              message!,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
