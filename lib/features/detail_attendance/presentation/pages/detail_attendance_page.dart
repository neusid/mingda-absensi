import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_network_image.dart';
import 'package:mingda_app/features/detail_attendance/presentation/widgets/card_detail_attendance.dart';
import 'package:mingda_app/features/detail_attendance/presentation/widgets/card_long_detail_attendance.dart';
import 'package:mingda_app/features/detail_attendance/presentation/widgets/image_not_found_widget.dart';

class DetailAttendancePage extends StatelessWidget {
  final ProfileEntity profileEntity;
  final AttendanceItemEntity attendanceItemEntity;
  const DetailAttendancePage({
    super.key,
    required this.profileEntity,
    required this.attendanceItemEntity,
  });

  Widget _buildAttendancePhoto(String? photo) {
    if (photo == null || photo.trim().isEmpty || photo.trim() == 'null') {
      return const ImageNotFoundWidget();
    }
    final cleanPhoto = photo.trim();
    if (cleanPhoto.startsWith('http://') || cleanPhoto.startsWith('https://')) {
      return ProfileNetworkImage(
        url: cleanPhoto,
        width: 158.w,
        height: 130.w,
        radius: 10.w,
        fit: BoxFit.cover,
        fallback: const ImageNotFoundWidget(),
      );
    }
    if (cleanPhoto.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Image.asset(
          cleanPhoto,
          width: 158.w,
          height: 130.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const ImageNotFoundWidget(),
        ),
      );
    }
    return const ImageNotFoundWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.shadowAppBar,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text(
          context.tr.backToDashboard,
          style: AppTextStyles.inter16MediumPrimary,
        ),
      ),
      backgroundColor: AppColors.bg,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 27.h),
          child: Column(
            children: [
              Container(
                width: 326.w,
                height: 81.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10.w),
                  boxShadow: [AppShadows.shadow094],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 55.w,
                          height: 55.w,
                          decoration: BoxDecoration(
                            color: AppColors.green250,
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: LottieBuilder.asset(
                            'assets/lottie/Success.json',
                            repeat: false,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Container(
                          width: 120.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profileEntity.name,
                                style: AppTextStyles.inter16RegularPrimary,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                attendanceItemEntity.attendanceDate.toLocalizedDateString(context.currentLanguage),
                                style: AppTextStyles.inter128RegularSecondary,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 66.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.w),
                        color: attendanceItemEntity.status.toLowerCase() == 'hadir'
                            ? AppColors.green2
                            : AppColors.red,
                      ),
                      child: Center(
                        child: Text(
                          attendanceItemEntity.localizedStatus(context.currentLanguage),
                          style: AppTextStyles.inter10RegularWhite,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17.w),
              Container(
                width: 326.w,
                height: 27.w,
                padding: EdgeInsets.only(left: 11.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [AppShadows.shadow094],
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.timeInformation,
                      style: AppTextStyles.inter11RegularPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              SizedBox(
                width: 327.w,
                height: 232.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDetailAttendance(
                          icon: 'assets/icon/barcode.svg',
                          title: context.tr.employeeCodeLabel,
                          subTitle: profileEntity.employeeCode,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/building.svg',
                          title: context.tr.departmentLabel,
                          subTitle: profileEntity.department.name,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDetailAttendance(
                          icon: 'assets/icon/briefcase.svg',
                          title: context.tr.positionLabel,
                          subTitle: profileEntity.position.name,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/call.svg',
                          title: context.tr.phoneLabel,
                          subTitle: profileEntity.phone,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 17.w),
              Container(
                width: 326.w,
                height: 27.w,
                padding: EdgeInsets.only(left: 11.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [AppShadows.shadow094],
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      context.tr.gpsInformation,
                      style: AppTextStyles.inter11RegularPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              SizedBox(
                width: 327.w,
                height: 232.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDetailAttendance(
                          icon: 'assets/icon/barcode.svg',
                          title: context.tr.inInformation,
                          subTitle: attendanceItemEntity.localizedStatus(context.currentLanguage),
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/building.svg',
                          title: context.tr.outLocation,
                          subTitle: attendanceItemEntity.gpsAccuracyIn
                              .toString(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDetailAttendance(
                          icon: 'assets/icon/briefcase.svg',
                          title: context.tr.checkIn,
                          subTitle: attendanceItemEntity.checkIn,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/call.svg',
                          title: context.tr.checkOut,
                          subTitle: attendanceItemEntity.checkOut,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.w),
              CardLongDetailAttendance(
                icon: 'assets/icon/barcode.svg',
                title: context.tr.notes,
                subTitle: attendanceItemEntity.localizedNotes(context.currentLanguage),
              ),
              SizedBox(height: 17.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    alignment: AlignmentGeometry.bottomCenter,
                    children: [
                      Container(
                        width: 158.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          color: AppColors.charcoalSlate,
                          boxShadow: [AppShadows.shadow094],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: _buildAttendancePhoto(attendanceItemEntity.photoIn),
                      ),
                      Container(
                        width: 158.w,
                        height: 27.w,
                        decoration: BoxDecoration(
                          color: AppColors.gray,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.w),
                            bottomRight: Radius.circular(10.w),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            context.tr.checkIn.toUpperCase(),
                            style: AppTextStyles.inter12RegularPrimary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: AlignmentGeometry.bottomCenter,
                    children: [
                      Container(
                        width: 158.w,
                        height: 130.w,
                        decoration: BoxDecoration(
                          color: AppColors.charcoalSlate,
                          boxShadow: [AppShadows.shadow094],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
                        child: _buildAttendancePhoto(attendanceItemEntity.photoOut),
                      ),
                      Container(
                        width: 158.w,
                        height: 27.w,
                        decoration: BoxDecoration(
                          color: AppColors.gray,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.w),
                            bottomRight: Radius.circular(10.w),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            context.tr.checkOut.toUpperCase(),
                            style: AppTextStyles.inter12RegularPrimary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
