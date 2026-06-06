import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class AttendanceActiveCardWidget extends StatelessWidget {
  final day;
  final clock;
  final description;
  const AttendanceActiveCardWidget({
    super.key,
    required this.day,
    required this.clock,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325.w,
      height: 65.w,
      padding: EdgeInsets.only(
        top: 7.5.w,
        bottom: 7.5.w,
        left: 7.5.w,
        right: 20.5.w,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
        color: AppColors.deepTeal,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            spacing: 14.w,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: AppColors.white,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icon/login.svg',
                    colorFilter: ColorFilter.mode(
                      AppColors.deepTeal,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5.w,
                children: [
                  Text(
                    'Masuk',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter14MediumActive,
                  ),
                  Text(
                    day,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.inter1102RegularActive,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 5.w,
            children: [
              Text(
                clock ?? '',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.inter14MediumActive,
              ),
              Text(
                description ?? '',
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.inter1102RegularActive,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
