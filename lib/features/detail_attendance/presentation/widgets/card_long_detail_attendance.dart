import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class CardLongDetailAttendance extends StatelessWidget {
  final icon;
  final title;
  final subTitle;
  const CardLongDetailAttendance({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      height: 111.w,
      padding: EdgeInsets.only(top: 16.w, left: 18.15.w, right: 13.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [AppShadows.shadow094],
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7.w,
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.w),
              color: AppColors.charcoalSlate50,
              boxShadow: [AppShadows.shadow094],
            ),
            child: Center(child: SvgPicture.asset(icon)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.inter96RegularSecondary,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subTitle ?? '',
                style: AppTextStyles.inter14MediumPrimary,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
