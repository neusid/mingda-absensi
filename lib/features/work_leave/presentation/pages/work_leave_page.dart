import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_item_card.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_skeleton.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_stat_card.dart';

class WorkLeavePage extends StatelessWidget {
  const WorkLeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkLeaveBloc>(
      create: (context) => sl<WorkLeaveBloc>()..add(const WorkLeaveEventFetch()),
      child: const _WorkLeaveView(),
    );
  }
}

class _WorkLeaveView extends StatelessWidget {
  const _WorkLeaveView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocBuilder<WorkLeaveBloc, WorkLeaveState>(
          builder: (context, state) {
            if (state is WorkLeaveLoadingState || state is WorkLeaveInitialState) {
              return const WorkLeaveSkeleton();
            }

            if (state is WorkLeaveFailureState) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48.w,
                        color: AppColors.red,
                      ),
                      SizedBox(height: 12.w),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 16.w),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.deepTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () {
                          context.read<WorkLeaveBloc>().add(const WorkLeaveEventFetch());
                        },
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is! WorkLeaveLoadedState) {
              return const SizedBox.shrink();
            }

            final summary = state.summary;
            final selectedStat = state.selectedStat;
            final filteredLeaves = state.filteredLeaves;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<WorkLeaveBloc>().add(const WorkLeaveEventFetch());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.w),

                    // ==================== 1. REKAP STATISTIK REAL API ====================
                    Row(
                      children: [
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.disetujui,
                            value: '${summary.approved}',
                            isSelected: selectedStat == WorkLeaveStatType.disetujui,
                            onTap: () {
                              context.read<WorkLeaveBloc>().add(
                                    const WorkLeaveEventFilterByStat(
                                      WorkLeaveStatType.disetujui,
                                    ),
                                  );
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.menunggu,
                            value: '${summary.pending}',
                            isSelected: selectedStat == WorkLeaveStatType.menunggu,
                            onTap: () {
                              context.read<WorkLeaveBloc>().add(
                                    const WorkLeaveEventFilterByStat(
                                      WorkLeaveStatType.menunggu,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),
                    Row(
                      children: [
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.ditolak,
                            value: '${summary.rejected}',
                            isSelected: selectedStat == WorkLeaveStatType.ditolak,
                            onTap: () {
                              context.read<WorkLeaveBloc>().add(
                                    const WorkLeaveEventFilterByStat(
                                      WorkLeaveStatType.ditolak,
                                    ),
                                  );
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.cutiTerpakai,
                            value: '${summary.leaveTaken}',
                            isSelected: selectedStat == WorkLeaveStatType.cutiTerpakai,
                            onTap: () {
                              context.read<WorkLeaveBloc>().add(
                                    const WorkLeaveEventFilterByStat(
                                      WorkLeaveStatType.cutiTerpakai,
                                    ),
                                  );
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.w),

                    // ==================== 2. FILTER STATUS & RELOAD ====================
                    Row(
                      children: [
                        Expanded(
                          child: _FilterDropdown(
                            value: selectedStat != null
                                ? selectedStat.label
                                : 'Semua Pengajuan',
                            onTap: () => _showFilterSheet(context, selectedStat),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _FilterIconButton(
                          icon: Icons.refresh_rounded,
                          onTap: () {
                            context.read<WorkLeaveBloc>().add(const WorkLeaveEventFetch());
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 20.w),

                    // ==================== 3. HEADER RIWAYAT REAL DATA ====================
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x080F172A),
                            blurRadius: 10.r,
                            offset: Offset(0, 2.w),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Riwayat Pengajuan Cuti (${filteredLeaves.length})',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Material(
                            color: AppColors.deepTeal,
                            borderRadius: BorderRadius.circular(8.r),
                            child: InkWell(
                              onTap: () {
                                // Dialog / Form Pengajuan Cuti Baru
                              },
                              borderRadius: BorderRadius.circular(8.r),
                              child: Padding(
                                padding: EdgeInsets.all(6.w),
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 18.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.w),

                    // ==================== 4. DAFTAR RIWAYAT PENGISIAN CUTI ====================
                    if (filteredLeaves.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 36.w),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_rounded,
                              size: 40.w,
                              color: const Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 8.w),
                            Text(
                              selectedStat != null
                                  ? 'Tidak ada pengajuan cuti berstatus "${selectedStat.label}"'
                                  : 'Belum ada riwayat pengajuan cuti',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredLeaves.length,
                        separatorBuilder: (context, index) => SizedBox(height: 10.w),
                        itemBuilder: (context, index) {
                          final item = filteredLeaves[index];
                          return WorkLeaveItemCard(
                            title: item.displayTitle,
                            status: item.displayStatus,
                            startDate: item.startDate,
                            endDate: item.endDate,
                            onTap: () {},
                          );
                        },
                      ),

                    SizedBox(height: 24.w),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WorkLeaveStatType? currentStat) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.w),
                Text(
                  'Filter Status Pengajuan',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 12.w),
                _buildFilterOption(
                  sheetContext,
                  context,
                  title: 'Semua Pengajuan',
                  isSelected: currentStat == null,
                  onTap: () {
                    context.read<WorkLeaveBloc>().add(
                          const WorkLeaveEventFilterByStat(null),
                        );
                    Navigator.pop(sheetContext);
                  },
                ),
                ...WorkLeaveStatType.values.map(
                  (type) => _buildFilterOption(
                    sheetContext,
                    context,
                    title: type.label,
                    color: type.accentColor,
                    isSelected: currentStat == type,
                    onTap: () {
                      context.read<WorkLeaveBloc>().add(
                            WorkLeaveEventFilterByStat(type),
                          );
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext sheetContext,
    BuildContext blocContext, {
    required String title,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.w),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF1F5F9) : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? const Color(0xFF64748B),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF0F172A),
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle_rounded, color: AppColors.deepTeal, size: 20.w)
            : null,
        onTap: onTap,
      ),
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;

  const _FilterDropdown({
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x060F172A),
            blurRadius: 8.r,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20.w,
                  color: const Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _FilterIconButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x060F172A),
            blurRadius: 8.r,
            offset: Offset(0, 2.w),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Icon(
              icon,
              size: 20.w,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }
}
