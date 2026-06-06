import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class CardDashboardWidget extends StatelessWidget {
  String icon;
  String title;
  String subTitle;
  String day;
  String description;
  CardDashboardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.day,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155.w,
      height: 126.w,
      padding: EdgeInsets.only(top: 15.w, left: 15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15.w,
        children: [
          Row(
            spacing: 10.w,
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: AppColors.charcoalSlate50,
                  borderRadius: BorderRadius.circular(7.w),
                ),
                child: Center(child: SvgPicture.asset('assets/icon/$icon.svg')),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.inter13MediumPrimary),
                  Text(subTitle, style: AppTextStyles.inter1013MediumSecondary),
                ],
              ),
            ],
          ),
          Column(
            spacing: 8.h,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$day days',
                style: AppTextStyles.inter18MediumPrimaryNoHeight,
              ),
              Text(description, style: AppTextStyles.inter102RegularSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
