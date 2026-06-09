import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_active_card_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_not_active_card_widget.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/card_history_attendance_widget.dart';

class HistoryAttendancePage extends StatelessWidget {
  const HistoryAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final historyAttendanceBloc = context.read<HistoryAttendanceBloc>();

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
      body: BlocConsumer<HistoryAttendanceBloc, HistoryAttendanceState>(
        bloc: historyAttendanceBloc,
        builder: (context, state) {
          if (state is HistoryAttendanceLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistoryAttendanceSuccessState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 20.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardHistoryAttendanceWidget(
                              color: AppColors.green250,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.hadir.toString(),
                              subTitle: 'TOTAL HADIR',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.yellow250,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.terlambat.toString(),
                              subTitle: 'TOTAL TERLAMBAT',
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardHistoryAttendanceWidget(
                              color: AppColors.red50,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.alpha.toString(),
                              subTitle: 'TOTAL ALPHA',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.charcoalSlate50,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.izin.toString(),
                              subTitle: 'TOTAL IZIN',
                            ),
                          ],
                        ),
                        SizedBox(height: 10.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CardHistoryAttendanceWidget(
                              color: AppColors.charcoalSlate50,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.cuti.toString(),
                              subTitle: 'TOTAL CUTI',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.charcoalSlate50,
                              icon: 'assets/icon/calendar.svg',
                              title: state.summaryEntity.sakit.toString(),
                              subTitle: 'TOTAL SAKIT',
                            ),
                          ],
                        ),
                        SizedBox(height: 22.w),
                        Container(
                          width: 326.w,
                          height: 27.w,
                          padding: EdgeInsets.only(left: 11.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.w),
                            boxShadow: [AppShadows.shadow094],
                            color: AppColors.white,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Riwayat Absensi - Month',
                                style: AppTextStyles.inter13RegularPrimary,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 22.w),
                      ],
                    ),
                  ),
                  SliverList.separated(
                    itemCount: state.historyEntity.data.length,
                    itemBuilder: (context, index) {
                      final attendance = state.historyEntity.data[index];
                      if (index == 0) {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                // Navigator.of(
                                //   context,
                                //   rootNavigator: true,
                                // ).pushNamed(
                                //   '/detail-attendance',
                                //   arguments: {
                                //     'profile': state.historyEntity,
                                //     'attendance': attendance,
                                //   },
                                // ),
                                true,
                            child: AttendanceActiveCardWidget(
                              status: attendance.status,
                              day: attendance.attendanceDate
                                  .toIndonesianDateString(),
                              checkIn: attendance.checkIn ?? '-',
                              checkOut: attendance.checkOut ?? '-',
                            ),
                          ),
                        );
                      } else {
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () =>
                                // Navigator.of(
                                //   context,
                                //   rootNavigator: true,
                                // ).pushNamed(
                                //   '/detail-attendance',
                                //   arguments: {
                                //     'profile': state.profileEntity,
                                //     'attendance': attendance,
                                //   },
                                // ),
                                true,
                            child: AttendanceNotActiveCardWidget(
                              status: attendance.status,
                              day: attendance.attendanceDate
                                  .toIndonesianDateString(),
                              checkIn: attendance.checkIn ?? '-',
                              checkOut: attendance.checkOut ?? '-',
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.w),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
