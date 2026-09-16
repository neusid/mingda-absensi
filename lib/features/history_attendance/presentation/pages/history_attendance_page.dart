import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_active_card_widget.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/attendance_not_active_card_widget.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/card_history_attendance_widget.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/history_skeleton.dart';

class HistoryAttendancePage extends StatefulWidget {
  const HistoryAttendancePage({super.key});

  @override
  State<HistoryAttendancePage> createState() => _HistoryAttendancePageState();
}

class _HistoryAttendancePageState extends State<HistoryAttendancePage> {
  Key attendanceDropdownKey = UniqueKey();
  Key monthDropdownKey = UniqueKey();

  AttendanceEnum? attendanceSelected;
  MonthEnum? monthSelected;
  int yearsSelected = DateTime.now().year;
  final List<int> listYears = List.generate(
    4,
    (index) => DateTime.now().year - index,
  );

  // Snapshot data terakhir untuk ditampilkan saat filter sedang loading
  AttendanceHistoryEntity? _lastHistory;
  AttendanceSummaryEntity? _lastSummary;

  void _applyFilter({int page = 1}) {
    final bloc = context.read<HistoryAttendanceBloc>();
    final current = bloc.state;
    if (current is! HistoryAttendanceLoadedState) return;
    bloc.add(
      HistoryAttendanceEventFiltered(
        historyEntity: current.historyEntity,
        summaryEntity: current.summaryEntity,
        page: page,
        month: (monthSelected?.index ?? DateTime.now().month - 1) + 1,
        year: yearsSelected,
        status: attendanceSelected,
      ),
    );
  }

  List<int> _visiblePages({required int current, required int last}) {
    const visiblePageCount = 3;
    int start = ((current - 1) ~/ visiblePageCount) * visiblePageCount + 1;
    int end = (start + visiblePageCount - 1).clamp(1, last);
    return List.generate(end - start + 1, (i) => start + i);
  }

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
            return const HistorySkeleton();
          }

          final bool isFilterLoading =
              state is HistoryAttendanceFilterLoadingState;
          final bool isError = state is HistoryAttendanceFailedFilterState;

          AttendanceHistoryEntity history;
          AttendanceSummaryEntity summary;
          if (state is HistoryAttendanceLoadedState) {
            // Simpan snapshot data terakhir agar bisa ditampilkan saat filter loading
            _lastHistory = state.historyEntity;
            _lastSummary = state.summaryEntity;
            history = state.historyEntity;
            summary = state.summaryEntity;
          } else if (isFilterLoading &&
              _lastHistory != null &&
              _lastSummary != null) {
            history = _lastHistory!;
            summary = _lastSummary!;
          } else {
            return Center(
              child: Text(
                'Failed to Get Profile',
                style: AppTextStyles.inter16MediumPrimary,
              ),
            );
          }

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
                            title: summary.hadir.toString(),
                            subTitle: 'TOTAL HADIR',
                          ),
                          CardHistoryAttendanceWidget(
                            color: AppColors.yellow250,
                            icon: 'assets/icon/calendar-search-2.svg',
                            title: summary.terlambat.toString(),
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
                            title: summary.alpha.toString(),
                            subTitle: 'TOTAL ALPHA',
                          ),
                          CardHistoryAttendanceWidget(
                            color: AppColors.charcoalSlate50,
                            icon: 'assets/icon/calendar-edit-2.svg',
                            title: summary.izin.toString(),
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
                            title: summary.cuti.toString(),
                            subTitle: 'TOTAL CUTI',
                          ),
                          CardHistoryAttendanceWidget(
                            color: AppColors.charcoalSlate50,
                            icon: 'assets/icon/calendar-add-2.svg',
                            title: summary.sakit.toString(),
                            subTitle: 'TOTAL SAKIT',
                          ),
                        ],
                      ),
                      SizedBox(height: 10.w),
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
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _FilterHeaderDelegate(
                    monthDropdownKey: monthDropdownKey,
                    attendanceDropdownKey: attendanceDropdownKey,
                    monthSelected: monthSelected,
                    attendanceSelected: attendanceSelected,
                    yearsSelected: yearsSelected,
                    listYears: listYears,
                    onMonthChanged: (value) {
                      setState(() {
                        monthSelected = value;
                      });
                      _applyFilter();
                    },
                    onAttendanceChanged: (value) {
                      setState(() {
                        attendanceSelected = value;
                      });
                      _applyFilter();
                    },
                    onYearChanged: (value) {
                      setState(() {
                        yearsSelected = value!;
                      });
                      _applyFilter();
                    },
                    onReset: () {
                      setState(() {
                        monthSelected = null;
                        attendanceSelected = null;
                        yearsSelected = DateTime.now().year;

                        monthDropdownKey = UniqueKey();
                        attendanceDropdownKey = UniqueKey();
                      });
                      _applyFilter();
                    },
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 10.w)),
                if (isFilterLoading)
                  SliverList.separated(
                    itemCount: 4,
                    itemBuilder: (context, index) => SkeletonLoading(
                      child: SkeletonBox(width: double.infinity, height: 65.w),
                    ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.w),
                  )
                else if (isError)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.w),
                      child: Center(
                        child: Text(
                          'Gagal memuat data. Coba lagi.',
                          style: AppTextStyles.inter14MediumSecondary,
                        ),
                      ),
                    ),
                  )
                else if (history.data.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60.w),
                      child: Center(
                        child: Text(
                          'Data kosong',
                          style: AppTextStyles.inter14MediumSecondary,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: history.data.length,
                    itemBuilder: (context, index) {
                      final attendance = history.data[index];
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
                if (history.lastPage > 1 && history.data.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.w),
                      child: Row(
                        spacing: 10.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: history.currentPage > 1
                                ? () => _applyFilter(
                                    page: history.currentPage - 1,
                                  )
                                : null,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [AppShadows.shadow094],
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icon/arrow-left.svg',
                                ),
                              ),
                            ),
                          ),
                          for (final p in _visiblePages(
                            current: history.currentPage,
                            last: history.lastPage,
                          ))
                            InkWell(
                              onTap: () => _applyFilter(page: p),
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: p == history.currentPage
                                      ? AppColors.deepTeal
                                      : AppColors.white,
                                  boxShadow: [AppShadows.shadow094],
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Text(
                                  p.toString(),
                                  style: p == history.currentPage
                                      ? AppTextStyles.inter12RegularPrimaryWhite
                                      : AppTextStyles.inter12RegularPrimary,
                                ),
                              ),
                            ),
                          InkWell(
                            onTap: history.currentPage < history.lastPage
                                ? () => _applyFilter(
                                    page: history.currentPage + 1,
                                  )
                                : null,
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [AppShadows.shadow094],
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icon/arrow-right.svg',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 50.w)),
              ],
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Key monthDropdownKey;
  final Key attendanceDropdownKey;
  final MonthEnum? monthSelected;
  final AttendanceEnum? attendanceSelected;
  final int yearsSelected;
  final List<int> listYears;
  final ValueChanged<MonthEnum?> onMonthChanged;
  final ValueChanged<AttendanceEnum?> onAttendanceChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onReset;

  _FilterHeaderDelegate({
    required this.monthDropdownKey,
    required this.attendanceDropdownKey,
    required this.monthSelected,
    required this.attendanceSelected,
    required this.yearsSelected,
    required this.listYears,
    required this.onMonthChanged,
    required this.onAttendanceChanged,
    required this.onYearChanged,
    required this.onReset,
  });

  @override
  double get minExtent => 121.w;

  @override
  double get maxExtent => 121.w;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.bg,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    decoration: InputDecoration(border: InputBorder.none),
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
                              style: AppTextStyles.inter14MediumSecondary,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onMonthChanged,
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
                    decoration: InputDecoration(border: InputBorder.none),
                    style: AppTextStyles.inter14MediumSecondary,
                    dropdownColor: AppColors.white,
                    initialValue: yearsSelected,
                    items: listYears
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: AppTextStyles.inter14MediumSecondary,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onYearChanged,
                  ),
                ),
              ],
            ),
            SizedBox(height: 11.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 270.w,
                  height: 45.w,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    color: AppColors.white,
                  ),
                  child: DropdownButtonFormField<AttendanceEnum>(
                    key: attendanceDropdownKey,
                    decoration: InputDecoration(border: InputBorder.none),
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
                              style: AppTextStyles.inter14MediumSecondary,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onAttendanceChanged,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(10.w),
                  onTap: onReset,
                  child: Ink(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: AppColors.white,
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/icon/trash.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) {
    return oldDelegate.monthDropdownKey != monthDropdownKey ||
        oldDelegate.attendanceDropdownKey != attendanceDropdownKey ||
        oldDelegate.monthSelected != monthSelected ||
        oldDelegate.attendanceSelected != attendanceSelected ||
        oldDelegate.yearsSelected != yearsSelected;
  }
}
