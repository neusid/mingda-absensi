import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class CardHistoryAttendanceWidget extends StatelessWidget {
  final color;
  final icon;
  final title;
  final subTitle;

  const CardHistoryAttendanceWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 159.w,
      height: 62.w,
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [AppShadows.shadow094],
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Center(child: SvgPicture.asset(icon)),
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.inter16MediumPrimary,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              Text(
                subTitle,
                style: AppTextStyles.inter8MediumSecondary,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
