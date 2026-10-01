import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/card_dashboard_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_network_image.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/dashboard_attendance_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _openHistory(BuildContext context, SuccessDashboardState state) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/history-attendance',
      arguments: {
        'history_attendance': state.attendanceHistoryEntity,
        'summary_attendance': state.attendanceSummaryEntity,
        'profile': state.profileEntity,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dasboardBloc = context.read<DashboardBloc>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocConsumer<DashboardBloc, DashboardState>(
        bloc: dasboardBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingDashboardState ||
              state is InitialDashboardState) {
            return const DashboardSkeleton();
          }

          if (state is FailureDashboardState ||
              state is FailureGetProfileDashboardState ||
              state is FailureGetAttendanceSummaryDashboardState ||
              state is FailureGetAttendanceHistoryDashboardState) {
            final message = state is FailureGetProfileDashboardState
                ? state.message
                : state is FailureGetAttendanceSummaryDashboardState
                ? state.message
                : state is FailureGetAttendanceHistoryDashboardState
                ? state.message
                : 'Gagal memuat data';

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48.w, color: Colors.grey),
                  SizedBox(height: 12.w),
                  Text(
                    'Gagal memuat data',
                    style: AppTextStyles.inter16MediumPrimary,
                  ),
                  if (message.isNotEmpty) ...[
                    SizedBox(height: 8.w),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.inter128RegularSecondary,
                      ),
                    ),
                  ],
                  SizedBox(height: 12.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => dasboardBloc.add(DashboardStarted()),
                        child: const Text('Coba lagi'),
                      ),
                      SizedBox(width: 12.w),
                      OutlinedButton(
                        onPressed: () => dasboardBloc.add(DashboardSignout()),
                        child: const Text('Login Ulang'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          if (state is SuccessDashboardState) {
            final recentAttendanceItems =
                DashboardAttendanceItem.fromAttendanceList(
              state.attendanceHistoryEntity.data,
              limit: 4,
            );
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
                                ProfileNetworkImage(
                                  url: state.profileEntity.profilePhotoUrl,
                                  width: 50.w,
                                  height: 50.w,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: Text(
                                        "Good Morning,",
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextStyles
                                            .inter128MediumSecondary,
                                      ),
                                    ),
                                    SizedBox(
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
                                    day: state.attendanceSummaryEntity.hadir
                                        .toString(),
                                    description: 'TOTAL PRESENT',
                                    onTap: () => _openHistory(context, state),
                                  ),
                                  CardDashboardWidget(
                                    icon: 'calendar-search',
                                    title: 'Terlambat',
                                    subTitle: 'this month',
                                    day: state
                                        .attendanceSummaryEntity
                                        .terlambat
                                        .toString(),
                                    description: 'TOTAL LATE',
                                    onTap: () => _openHistory(context, state),
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
                                    day: (state.attendanceSummaryEntity.izin +
                                            state.attendanceSummaryEntity.sakit)
                                        .toString(),
                                    description: 'WORK PERMIT',
                                    onTap: () => _openHistory(context, state),
                                  ),
                                  CardDashboardWidget(
                                    icon: 'calendar',
                                    title: 'Sisa Cuti',
                                    subTitle: 'this month',
                                    day: state.attendanceSummaryEntity.cuti
                                        .toString(),
                                    description: 'WORK LEAVE',
                                    onTap: () => _openHistory(context, state),
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
                              Container(
                                width: 96.w,
                                height: 27.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.w),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0F766E),
                                      Color(0xFF14B8A6),
                                    ],
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5.w),
                                    onTap: () {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pushNamed(
                                        '/history-attendance',
                                        arguments: {
                                          'history_attendance':
                                              state.attendanceHistoryEntity,
                                          'summary_attendance':
                                              state.attendanceSummaryEntity,
                                          'profile': state.profileEntity,
                                        },
                                      );
                                    },
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
                  if (recentAttendanceItems.isEmpty)
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 24.w),
                        alignment: Alignment.center,
                        child: Text(
                          'Belum ada riwayat absensi',
                          style: AppTextStyles.inter128RegularSecondary,
                        ),
                      ),
                    )
                  else
                    SliverList.separated(
                      itemCount: recentAttendanceItems.length,
                      itemBuilder: (context, index) {
                        final item = recentAttendanceItems[index];
                        return DashboardAttendanceCard(
                          item: item,
                          onTap: () {
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pushNamed(
                              '/detail-attendance',
                              arguments: {
                                'profile': state.profileEntity,
                                'attendance': item.attendance,
                              },
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.w),
                    ),
                  SliverToBoxAdapter(child: SizedBox(height: 16.w)),
                ],
              ),
            );
          }

          return const DashboardSkeleton();
        },
      ),
    );
  }
}
