import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/widgets/mingda_page_loading.dart';
import 'package:mingda_app/core/widgets/mingda_page_transition_wrapper.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_history_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/attendance_summary_entity.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';
import 'package:mingda_app/features/history_attendance/presentation/blocs/history_attendance_bloc.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/attendance_stat_card.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/dashboard_attendance_card.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/filter_dropdowns.dart';
import 'package:mingda_app/features/history_attendance/presentation/widgets/history_skeleton.dart';

class HistoryAttendancePage extends StatefulWidget {
  final ProfileEntity? profileEntity;
  const HistoryAttendancePage({super.key, this.profileEntity});

  @override
  State<HistoryAttendancePage> createState() => _HistoryAttendancePageState();
}

class _HistoryAttendancePageState extends State<HistoryAttendancePage> {
  bool _isPageTransitioning = true;
  AttendanceEnum? attendanceSelected;
  MonthEnum? monthSelected;
  int yearsSelected = DateTime.now().year;
  final List<int> listYears = List.generate(
    4,
    (index) => DateTime.now().year - index,
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isPageTransitioning = false;
        });
      }
    });
  }

  // Snapshot data terakhir untuk ditampilkan saat filter sedang loading
  AttendanceHistoryEntity? _lastHistory;
  AttendanceSummaryEntity? _lastSummary;

  void _applyFilter({int page = 1}) {
    final bloc = context.read<HistoryAttendanceBloc>();
    final current = bloc.state;
    if (current is! HistoryAttendanceLoadedState) return;

    final int? selectedMonth =
        monthSelected != null ? monthSelected!.index + 1 : null;

    bloc.add(
      HistoryAttendanceEventFiltered(
        historyEntity: current.historyEntity,
        summaryEntity: current.summaryEntity,
        page: page,
        month: selectedMonth,
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

  ProfileEntity get _effectiveProfile =>
      widget.profileEntity ??
      const ProfileEntity(
        id: 1,
        employeeCode: 'MD-2024-001',
        nik: '3578012345670001',
        name: 'Karyawan',
        gender: 'Laki-laki',
        birthPlace: 'Surabaya',
        birthDate: '2000-01-01',
        maritalStatus: 'Belum Menikah',
        agama: 'Islam',
        bangsa: 'Indonesia',
        statusKependudukan: 'WNI',
        tanggunganAnak: 0,
        namaIbuKandung: 'Ibu',
        ktp: '3578012345670001',
        kartuKeluarga: '3578012345670002',
        departmentId: 1,
        subDepartmentId: 1,
        positionId: 1,
        joinDate: '2023-01-01',
        employmentStatus: 'Karyawan Tetap',
        serikat: 'Tidak',
        lulusanSekolah: 'S1',
        workScheduleId: 1,
        bank: 'BCA',
        nomorRekening: '1234567890',
        taxNpwp: '12.345.678.9-000.000',
        bpjsKesehatan: '00000000000',
        bpjsKetenagakerjaan: '00000000000',
        address: 'Kantor Mingda',
        city: 'Surabaya',
        province: 'Jawa Timur',
        desa: '-',
        kecamatan: '-',
        kabupaten: 'Surabaya',
        postalCode: '60000',
        phone: '08123456789',
        email: 'karyawan@mingda.co.id',
        emergencyContactName: '-',
        emergencyContactPhone: '-',
        userId: 1,
        status: 'active',
        profilePhoto: 'assets/img/mingda_logo.png',
        createdAt: '2023-01-01',
        updatedAt: '2023-01-01',
        shiftType: 'Normal',
        profilePhotoUrl: '',
        department: DepartmentEntity(
          id: 1,
          name: 'General',
          description: '-',
          createdAt: '2023-01-01',
          updatedAt: '2023-01-01',
        ),
        position: PositionEntity(
          id: 1,
          code: 'STF',
          name: 'Staff',
          description: '-',
          status: 'active',
          createdAt: '2023-01-01',
          updatedAt: '2023-01-01',
          displayName: 'Staff',
        ),
        workSchedule: WorkScheduleEntity(
          id: 1,
          name: 'Reguler',
          startTime: '08:00',
          endTime: '17:00',
          lateTolerance: 15,
          overtimeThreshold: 30,
          isActive: true,
          createdAt: '2023-01-01',
          updatedAt: '2023-01-01',
        ),
      );

  void _openDetail(AttendanceItemEntity attendance) {
    Navigator.of(context, rootNavigator: true).pushNamed(
      '/detail-attendance',
      arguments: {
        'profile': _effectiveProfile,
        'attendance': attendance,
      },
    );
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
          Widget content;
          // Tier 1: Initial mount / route transition
          if (_isPageTransitioning || state is HistoryAttendanceInitialState) {
            content = const KeyedSubtree(
              key: ValueKey('ha_loading'),
              child: MingdaPageLoading(),
            );
          } else if (state is HistoryAttendanceEarlyLoadingState) {
            content = const KeyedSubtree(
              key: ValueKey('ha_skeleton'),
              child: HistorySkeleton(),
            );
          } else {
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
              content = KeyedSubtree(
                key: const ValueKey('ha_failed'),
                child: Center(
                  child: Text(
                    'Failed to Get Profile',
                    style: AppTextStyles.inter16MediumPrimary,
                  ),
                ),
              );
              return MingdaPageTransitionWrapper(child: content);
            }

            final attendanceItems = DashboardAttendanceItem.fromAttendanceList(
              history.data,
              treatLatestAsToday: monthSelected == null,
            );

            content = KeyedSubtree(
              key: const ValueKey('ha_content'),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 20.w),
                      Row(
                        children: [
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.hadir,
                              count: summary.hadir,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.terlambat,
                              count: summary.terlambat,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.alpha,
                              count: summary.alpha,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.izin,
                              count: summary.izin,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.w),
                      Row(
                        children: [
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.cuti,
                              count: summary.cuti,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: AttendanceStatCard(
                              type: AttendanceStatType.sakit,
                              count: summary.sakit,
                            ),
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
                              'Riwayat Absensi${attendanceSelected != null ? " - ${attendanceSelected!.name}" : ""}${monthSelected != null ? " - ${monthSelected!.name}" : ""} $yearsSelected',
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
                      child: SkeletonBox(width: double.infinity, height: 76.w),
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
                else if (attendanceItems.isEmpty)
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
                    itemCount: attendanceItems.length,
                    itemBuilder: (context, index) {
                      final item = attendanceItems[index];
                      return DashboardAttendanceCard(
                        key: ValueKey('history_${item.attendance.id}_$index'),
                        item: item,
                        onTap: () => _openDetail(item.attendance),
                      );
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
          ),
        );
      }

      return MingdaPageTransitionWrapper(child: content);
    },
        listener: (context, state) {},
      ),
    );
  }
}

class _FilterHeaderDelegate extends SliverPersistentHeaderDelegate {
  final MonthEnum? monthSelected;
  final AttendanceEnum? attendanceSelected;
  final int yearsSelected;
  final List<int> listYears;
  final ValueChanged<MonthEnum?> onMonthChanged;
  final ValueChanged<AttendanceEnum?> onAttendanceChanged;
  final ValueChanged<int?> onYearChanged;
  final VoidCallback onReset;

  _FilterHeaderDelegate({
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
  double get minExtent => 134.w;

  @override
  double get maxExtent => 134.w;

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
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            boxShadow: [AppShadows.shadow094],
            color: AppColors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // === ROW 1: Month Dropdown + Year Dropdown ===
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: MonthFilterDropdown(
                      selected: monthSelected,
                      onChanged: onMonthChanged,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SizedBox(
                    width: 110.w,
                    child: YearFilterDropdown(
                      selected: yearsSelected,
                      years: listYears,
                      onChanged: onYearChanged,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              // === ROW 2: Status Dropdown + Reset Button ===
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: StatusFilterDropdown(
                      selected: attendanceSelected,
                      onChanged: onAttendanceChanged,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  // Reset Button (teal gradient)
                  Container(
                    width: 110.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.filterGradientStart,
                          AppColors.filterGradientEnd,
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10.w),
                        canRequestFocus: false,
                        onTap: onReset,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: 16.w,
                              color: AppColors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Reset',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _FilterHeaderDelegate oldDelegate) {
    return oldDelegate.monthSelected != monthSelected ||
        oldDelegate.attendanceSelected != attendanceSelected ||
        oldDelegate.yearsSelected != yearsSelected;
  }
}
