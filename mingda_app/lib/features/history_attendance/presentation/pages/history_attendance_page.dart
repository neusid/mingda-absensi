import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_active_card_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_not_active_card_widget.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/card_history_attendance_widget.dart';

class HistoryAttendancePage extends StatefulWidget {
  HistoryAttendancePage({super.key});

  @override
  State<HistoryAttendancePage> createState() => _HistoryAttendancePageState();
}

class _HistoryAttendancePageState extends State<HistoryAttendancePage> {
  Key attendanceDropdownKey = UniqueKey();
  Key monthDropdownKey = UniqueKey();

  AttendanceEnum? attendanceSelected;
  MonthEnum? monthSelected;
  int yearsSelected = DateTime.now().year;
  final List<int> ListYears = List.generate(
    4,
    (index) => DateTime.now().year - index,
  );

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
          if (state is HistoryAttendanceEarlyLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HistoryAttendanceLoadedState) {
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
                              icon: 'assets/icon/calendar-tick-2.svg',
                              title: state.summaryEntity.hadir.toString(),
                              subTitle: 'TOTAL HADIR',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.yellow250,
                              icon: 'assets/icon/calendar-search-2.svg',
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
                              icon: 'assets/icon/calendar-remove-2.svg',
                              title: state.summaryEntity.alpha.toString(),
                              subTitle: 'TOTAL ALPHA',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.charcoalSlate50,
                              icon: 'assets/icon/calendar-edit-2.svg',
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
                              icon: 'assets/icon/calendar-clock-2.svg',
                              title: state.summaryEntity.cuti.toString(),
                              subTitle: 'TOTAL CUTI',
                            ),
                            CardHistoryAttendanceWidget(
                              color: AppColors.charcoalSlate50,
                              icon: 'assets/icon/calendar-add-2.svg',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 205.w,
                              height: 45.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.white,
                              ),
                              child: DropdownButtonFormField<MonthEnum>(
                                key: monthDropdownKey,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                isExpanded: true,
                                hint: Center(
                                  child: Text(
                                    "-- default --",
                                    style: AppTextStyles.inter14MediumSecondary,
                                  ),
                                ),
                                style: AppTextStyles.inter14MediumSecondary,
                                dropdownColor: AppColors.white,
                                items: MonthEnum.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.name,
                                          style: AppTextStyles
                                              .inter14MediumSecondary,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() {
                                  monthSelected = value;
                                }),
                              ),
                            ),
                            Container(
                              width: 110.w,
                              height: 45.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.white,
                              ),
                              child: DropdownButtonFormField<int>(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: AppTextStyles.inter14MediumSecondary,
                                dropdownColor: AppColors.white,
                                initialValue: yearsSelected,
                                items: ListYears.map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e.toString(),
                                      style:
                                          AppTextStyles.inter14MediumSecondary,
                                    ),
                                  ),
                                ).toList(),
                                onChanged: (value) => setState(() {
                                  yearsSelected = value!;
                                }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 11.w),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 205.w,
                              height: 45.w,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.white,
                              ),
                              child: DropdownButtonFormField<AttendanceEnum>(
                                key: attendanceDropdownKey,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                isExpanded: true,
                                hint: Center(
                                  child: Text(
                                    "-- default --",
                                    style: AppTextStyles.inter14MediumSecondary,
                                  ),
                                ),

                                style: AppTextStyles.inter14MediumSecondary,
                                dropdownColor: AppColors.white,
                                items: AttendanceEnum.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.name,
                                          style: AppTextStyles
                                              .inter14MediumSecondary,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) => setState(() {
                                  attendanceSelected = value;
                                }),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.w),
                              onTap: () => monthSelected != null
                                  ? historyAttendanceBloc.add(
                                      HistoryAttendanceEventFiltered(
                                        historyEntity: state.historyEntity,
                                        summaryEntity: state.summaryEntity,
                                        page: 1,
                                        month: (monthSelected?.index ?? 0) + 1,
                                        year: yearsSelected,
                                        status: attendanceSelected,
                                      ),
                                    )
                                  : null,
                              child: Ink(
                                width: 45.w,
                                height: 45.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  color: AppColors.white,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icon/sort.svg',
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.w),
                              onTap: () {
                                setState(() {
                                  monthSelected = null;
                                  attendanceSelected = null;
                                  yearsSelected = DateTime.now().year;

                                  monthDropdownKey = UniqueKey();
                                  attendanceDropdownKey = UniqueKey();
                                });
                              },
                              child: Ink(
                                width: 45.w,
                                height: 45.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  color: AppColors.white,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icon/trash.svg',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 22.w),
                      ],
                    ),
                  ),
                  state is HistoryAttendanceFailedFilterState
                      ? SliverToBoxAdapter(
                          child: Center(child: Text("Data kosong")),
                        )
                      : SliverList.separated(
                          itemCount: state.historyEntity.data.length,
                          itemBuilder: (context, index) {
                            final attendance = state.historyEntity.data[index];
                            if (index == 0) {
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => true,
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
                                  onTap: () => true,
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
            return Center(
              child: Text(
                'Failed to Get Profile',
                style: AppTextStyles.inter16MediumPrimary,
              ),
            );
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}
