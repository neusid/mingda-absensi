import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_active_card_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_not_active_card_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/card_dashboard_widget.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  ProfileEntity? entity;

  @override
  Widget build(BuildContext context) {
    final dasboardBloc = context.read<DashboardBloc>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dasboardBloc,
        listener: (context, state) {
          // TODO: implement listener
          if (state is SignoutDashboardState) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        builder: (context, state) {
          if (state is SuccessDashboardState) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 58.w),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 20.w,
                              children: [
                                Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.w),
                                    border: Border.all(
                                      color: Color(0xFF8E8E8E),
                                      width: 1.w,
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        state.profileEntity.profilePhotoUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      child: Text(
                                        "Good Morning,",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles
                                            .inter128MediumSecondary,
                                      ),
                                    ),
                                    Container(
                                      width: 200.w,
                                      child: Text(
                                        state.profileEntity.name,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            AppTextStyles.inter16MediumPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.w),
                              onTap: () => true,
                              child: Ink(
                                width: 40.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  boxShadow: [AppShadows.shadow094],
                                  color: AppColors.white,
                                ),
                                child: Icon(Icons.notifications),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateTime.now().toIndonesianString(),
                              style: AppTextStyles.inter96MediumPrimary,
                            ),
                            Container(
                              width: 156.w,
                              height: 26.w,
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.deepTeal,
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 15.w,
                                    height: 15.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "${state.profileEntity.position.name} - ${state.profileEntity.position.status}",
                                    style: AppTextStyles.inter96RegularWhite,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 17.w),
                        SizedBox(
                          height: 267.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CardDashboardWidget(
                                    icon: 'calendar-tick',
                                    title: 'Hadir',
                                    subTitle: 'this month',
                                    day:
                                        state.attendanceSummaryEntity.hadir
                                            .toString() ??
                                        '0',
                                    description: 'TOTAL PRESENT',
                                  ),
                                  CardDashboardWidget(
                                    icon: 'calendar-search',
                                    title: 'Terlambat',
                                    subTitle: 'this month',
                                    day:
                                        state
                                            .attendanceSummaryEntity
                                            .totalLateMinutes
                                            .toString() ??
                                        '0',
                                    description: 'TOTAL LATE',
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CardDashboardWidget(
                                    icon: 'calendar-remove',
                                    title: 'Izin Sakit',
                                    subTitle: 'this month',
                                    day:
                                        state.attendanceSummaryEntity.izin
                                            .toString() ??
                                        '0',
                                    description: 'WORK PERMIT',
                                  ),
                                  CardDashboardWidget(
                                    icon: 'calendar',
                                    title: 'Sisa Cuti',
                                    subTitle: 'this month',
                                    day: state.attendanceSummaryEntity.cuti
                                        .toString(),
                                    description: 'WORK LEAVE',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 17.w),
                        Container(
                          width: 326.w,
                          height: 40.w,
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.5.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.w),
                            boxShadow: [AppShadows.shadow094],
                            color: AppColors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Your activity',
                                style: AppTextStyles.inter14MediumPrimary,
                              ),
                              Material(
                                child: InkWell(
                                  onTap: () {},
                                  child: Ink(
                                    width: 96.w,
                                    height: 27.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.w),
                                      color: AppColors.deepTeal,
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.deepTeal,
                                          AppColors.blueGradient,
                                        ],
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'View all',
                                        style: AppTextStyles.inter12MediumWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 17.w),
                      ],
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.attendanceHistoryEntity.data.length,
                    itemBuilder: (context, index) {
                      final attendance =
                          state.attendanceHistoryEntity.data[index];
                      if (index == 0) {
                        return AttendanceActiveCardWidget(
                          day: attendance.attendanceDate
                              .toIndonesianDateString(),
                          clock: attendance.checkIn,
                          description: attendance.notes,
                        );
                      } else {
                        return AttendanceNotActiveCardWidget(
                          day: attendance.attendanceDate
                              .toIndonesianDateString(),
                          clock: attendance.checkIn,
                          description: attendance.notes,
                        );
                      }
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.w),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 17.w),
                        ElevatedButton(
                          onPressed: () => dasboardBloc.add(DashboardSignout()),
                          child: Text(
                            "Logout",
                            style: AppTextStyles.inter18RegularPrimary,
                          ),
                        ),
                        SizedBox(height: 50.w),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
