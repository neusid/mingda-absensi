import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/detail_attendance/presentation/widgets/card_detail_attendance.dart';
import 'package:mingda_app/features/detail_attendance/presentation/widgets/card_long_detail_attendance.dart';

class DetailAttendancePage extends StatelessWidget {
  ProfileEntity profileEntity;
  AttendanceItemEntity attendanceItemEntity;
  DetailAttendancePage({
    super.key,
    required this.profileEntity,
    required this.attendanceItemEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: AppColors.shadowAppBar,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text(
          'Back to Dashboard',
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
                                "${attendanceItemEntity.attendanceDate.toIndonesianDateString()}",
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
                        color: attendanceItemEntity.status == 'hadir'
                            ? AppColors.green2
                            : AppColors.red,
                      ),
                      child: Center(
                        child: attendanceItemEntity.status == 'hadir'
                            ? Text(
                                attendanceItemEntity.status,
                                style: AppTextStyles.inter10RegularWhite,
                                overflow: TextOverflow.ellipsis,
                              )
                            : Text(
                                attendanceItemEntity.status,
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
                      "Informasi waktu",
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
                          title: 'Kode',
                          subTitle: profileEntity.employeeCode,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/building.svg',
                          title: 'Department',
                          subTitle: profileEntity.department.name,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardDetailAttendance(
                          icon: 'assets/icon/briefcase.svg',
                          title: 'Jabatan',
                          subTitle: profileEntity.position.name,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/call.svg',
                          title: 'Phone',
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
                      "Informasi GPS",
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
                          title: 'Informasi Masuk',
                          subTitle: attendanceItemEntity.status,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/building.svg',
                          title: 'Lokasi Keluar',
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
                          title: 'Check In',
                          subTitle: attendanceItemEntity.checkIn,
                        ),
                        CardDetailAttendance(
                          icon: 'assets/icon/call.svg',
                          title: 'Check Out',
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
                title: 'Catatan',
                subTitle: attendanceItemEntity.notes,
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
                          color: AppColors.white,
                          boxShadow: [AppShadows.shadow094],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
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
                            'CHECK IN',
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
                        padding: EdgeInsets.only(
                          top: 22.w,
                          left: 35.w,
                          right: 35.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.charcoalSlate,
                          boxShadow: [AppShadows.shadow094],
                          borderRadius: BorderRadius.circular(10.w),
                        ),
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
                            'CHECK OUT',
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
