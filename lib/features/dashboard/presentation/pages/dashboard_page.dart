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
import 'package:mingda_app/features/dashboard/presentation/widgets/announcement_carousel_widget.dart';

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

  String _formatStatus(String status) {
    if (status.isEmpty) return '';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
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
                              canRequestFocus: false,
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
                            SizedBox(width: 8.w),
                            Flexible(
                              child: Container(
                                height: 26.w,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0F766E), // Teal 700
                                      Color(0xFF14B8A6), // Teal 500
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.w),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x200F766E),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 7.w,
                                      height: 7.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4ADE80),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4ADE80)
                                                .withValues(alpha: 0.6),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Flexible(
                                      child: Text(
                                        "${state.profileEntity.position.name} • ${_formatStatus(state.profileEntity.position.status)}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                        const AnnouncementCarouselWidget(),
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
                                    canRequestFocus: false,
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
                          key: ValueKey('dash_${item.attendance.id}_$index'),
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
