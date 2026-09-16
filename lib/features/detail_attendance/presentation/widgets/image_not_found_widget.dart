import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 22.w),
      child: Column(
        children: [
          SvgPicture.asset(
            'assets/icon/gallery-slash.svg',
            width: 32.w,
            height: 32.w,
          ),
          SizedBox(height: 10.w),
          Text(
            'Belum tersedia',
            style: AppTextStyles.inter10RegularWhite,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
