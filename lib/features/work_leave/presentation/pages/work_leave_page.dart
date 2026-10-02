import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/add_work_leave_page.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_detail_sheet.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_filter_dropdown.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_item_card.dart';
import 'package:mingda_app/core/routes/mingda_page_route.dart';
import 'package:mingda_app/core/widgets/mingda_page_loading.dart';
import 'package:mingda_app/core/widgets/mingda_page_transition_wrapper.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_policy_banner.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_policy_dialog.dart';
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

class _WorkLeaveView extends StatefulWidget {
  const _WorkLeaveView();

  @override
  State<_WorkLeaveView> createState() => _WorkLeaveViewState();
}

class _WorkLeaveViewState extends State<_WorkLeaveView> {
  bool _isPageTransitioning = true;

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

  void _openAddLeave(BuildContext context) {
    final bloc = context.read<WorkLeaveBloc>();
    Navigator.of(context, rootNavigator: true).push(
      MingdaPageRoute(
        child: BlocProvider.value(
          value: bloc,
          child: const AddWorkLeavePage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: BlocBuilder<WorkLeaveBloc, WorkLeaveState>(
          builder: (context, state) {
            Widget content;
            // Tier 1: Initial mount / route transition
            if (_isPageTransitioning || state is WorkLeaveInitialState) {
              content = const KeyedSubtree(
                key: ValueKey('wl_loading'),
                child: MingdaPageLoading(),
              );
            } else if (state is WorkLeaveLoadingState) {
              content = const KeyedSubtree(
                key: ValueKey('wl_skeleton'),
                child: WorkLeaveSkeleton(),
              );
            } else if (state is WorkLeaveFailureState) {
              content = KeyedSubtree(
                key: const ValueKey('wl_failure'),
                child: Center(
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
                ),
              );
            } else if (state is WorkLeaveLoadedState) {
              final summary = state.summary;
              final selectedStat = state.selectedStat;
              final filteredLeaves = state.filteredLeaves;

              content = KeyedSubtree(
                key: const ValueKey('wl_content'),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<WorkLeaveBloc>().add(const WorkLeaveEventFetch());
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.w),

                    // ==================== 0. BANNER EDUKASI & KEBIJAKAN CUTI ====================
                    WorkLeavePolicyBanner(
                      onTap: () => WorkLeavePolicyDialog.show(context),
                    ),

                    SizedBox(height: 14.w),

                    // ==================== 1. REKAP STATISTIK REAL API ====================
                    Row(
                      children: [
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.disetujui,
                            value: '${summary.approved}',
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.menunggu,
                            value: '${summary.pending}',
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
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: WorkLeaveStatCard(
                            type: WorkLeaveStatType.cutiTerpakai,
                            value: '${summary.leaveTaken}',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18.w),

                    // ==================== 2. FILTER STATUS & RELOAD ====================
                    Row(
                      children: [
                        Expanded(
                          child: WorkLeaveStatusFilterDropdown(
                            selected: selectedStat,
                            onChanged: (stat) {
                              context.read<WorkLeaveBloc>().add(
                                    WorkLeaveEventFilterByStat(stat),
                                  );
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        _FilterIconButton(
                          icon: Icons.refresh_rounded,
                          onTap: () {
                            context.read<WorkLeaveBloc>().add(
                                  const WorkLeaveEventFetch(),
                                );
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
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [AppShadows.shadow094],
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Riwayat Pengajuan Cuti (${filteredLeaves.length})',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF0F766E),
                                  Color(0xFF14B8A6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x250F766E),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _openAddLeave(context),
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
                            SizedBox(height: 10.w),
                            TextButton.icon(
                              onPressed: () => _openAddLeave(context),
                              icon: Icon(
                                Icons.add_rounded,
                                size: 16.w,
                                color: const Color(0xFF0D9488),
                              ),
                              label: Text(
                                'Buat Pengajuan Baru',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0D9488),
                                ),
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
                            onTap: () => WorkLeaveDetailSheet.show(context, item),
                          );
                        },
                      ),

                    SizedBox(height: 24.w),
                  ],
                ),
              ),
            ),
          );
        } else {
          content = const KeyedSubtree(
            key: ValueKey('wl_empty'),
            child: SizedBox.shrink(),
          );
        }

            return MingdaPageTransitionWrapper(child: content);
          },
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
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.w),
          splashColor: const Color(0xFF0D9488).withValues(alpha: 0.12),
          highlightColor: const Color(0xFF0D9488).withValues(alpha: 0.05),
          child: Center(
            child: Icon(
              icon,
              size: 20.w,
              color: const Color(0xFF0D9488),
            ),
          ),
        ),
      ),
    );
  }
}
