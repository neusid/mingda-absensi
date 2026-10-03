import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/widgets/mingda_page_loading.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_card.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_filter_dropdown.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_policy_banner.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_policy_dialog.dart';
import 'package:mingda_app/features/warning_letter/presentation/widgets/warning_letter_skeleton.dart';

class WarningLetterPage extends StatefulWidget {
  const WarningLetterPage({super.key});

  @override
  State<WarningLetterPage> createState() => _WarningLetterPageState();
}

class _WarningLetterPageState extends State<WarningLetterPage> {
  // Tier 1: Initial mount / route transition
  bool _isInitialLoading = true;
  // Tier 2: Data fetching in progress
  bool _isFetching = false;

  WarningLetterType? _selectedType;
  WarningLetterStatus? _selectedStatus;

  WarningLetterType? _appliedType;
  WarningLetterStatus? _appliedStatus;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _isInitialLoading = false;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    setState(() => _isFetching = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() => _isFetching = false);
    }
  }

  /// Data Surat Peringatan sesuai schema REST API Mingda (/mobile/v1/warning-letters/*)
  static const List<WarningLetterItemData> _allWarnings = [
    WarningLetterItemData(
      id: 1,
      spNumber: 'SP/001/HRD/I/2026',
      spLevel: 'SP 1',
      title: 'Keterlambatan',
      description:
          'Terlambat 3x berturut-turut dalam seminggu. '
          'Perlu penagihan kedisiplinan dan pembinaan kehadiran.',
      status: 'active',
      issuedDate: '10 Jan 2026',
      validUntil: '10 Jul 2026',
      attachmentUrl: '/mobile/v1/warning-letters/1/download',
    ),
    WarningLetterItemData(
      id: 2,
      spNumber: 'SP/002/HRD/IV/2026',
      spLevel: 'SP 2',
      title: 'Pelanggaran SOP',
      description:
          'Tidak mengikuti prosedur K3 pada shift malam. '
          'Perlu pelatihan ulang operasional keselamatan kerja.',
      status: 'active',
      issuedDate: '02 Apr 2026',
      validUntil: '02 Okt 2026',
      attachmentUrl: '/mobile/v1/warning-letters/2/download',
    ),
    WarningLetterItemData(
      id: 3,
      spNumber: 'SP/003/HRD/II/2026',
      spLevel: 'SP 1',
      title: 'Absensi',
      description:
          'Tidak hadir tanpa keterangan selama 2 hari kerja. '
          'Sudah ditindaklanjuti dan masa pembinaan telah selesai.',
      status: 'completed',
      issuedDate: '25 Feb 2026',
      validUntil: '25 Ags 2026',
      attachmentUrl: '/mobile/v1/warning-letters/3/download',
    ),
    WarningLetterItemData(
      id: 4,
      spNumber: 'SP/004/HRD/VI/2026',
      spLevel: 'SP 3',
      title: 'Disiplin',
      description:
          'Pelanggaran aturan seragam kerja dan etika operasional. '
          'Perlu evaluasi kedisiplinan tingkat akhir.',
      status: 'active',
      issuedDate: '01 Jun 2026',
      validUntil: '01 Des 2026',
      attachmentUrl: '/mobile/v1/warning-letters/4/download',
    ),
  ];

  List<WarningLetterItemData> get _filteredWarnings {
    return _allWarnings.where((item) {
      if (_appliedType != null && item.spLevel != _appliedType!.label) {
        return false;
      }
      if (_appliedStatus != null &&
          item.displayStatus != _appliedStatus!.label) {
        return false;
      }
      return true;
    }).toList();
  }

  void _applySearch() {
    setState(() {
      _appliedType = _selectedType;
      _appliedStatus = _selectedStatus;
    });
  }

  void _resetFilters() {
    setState(() {
      _selectedType = null;
      _selectedStatus = null;
      _appliedType = null;
      _appliedStatus = null;
    });
  }

  void _handleDownload(WarningLetterItemData item) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF0F766E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        content: Row(
          children: [
            Icon(Icons.download_done_rounded, size: 18.w, color: Colors.white),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                '${context.tr.downloadingPhysicalFile} ${item.spNumber}...',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tier 1: Initial mount / route transition
    if (_isInitialLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: MingdaPageLoading(),
      );
    }

    // Tier 2: Fetching data in progress
    if (_isFetching) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: WarningLetterSkeleton(),
          ),
        ),
      );
    }

    final filteredList = _filteredWarnings;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.filterTealAccent,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.w),

                    // ==================== 0. BANNER EDUKASI & SOP KEDISIPLINAN ====================
                    WarningLetterPolicyBanner(
                      onTap: () => WarningLetterPolicyDialog.show(context),
                    ),

                    SizedBox(height: 14.w),

                    // ==================== 1. KARTU STATISTIK SP ====================
                    // 2 kartu statistik atas
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.warning_amber_rounded,
                            value: '1',
                            label: context.tr.spActiveUpper,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle_outline_rounded,
                            value: '12',
                            label: context.tr.spCompletedUpper,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.w),

                    // 1 kartu statistik lebar
                    _StatCard(
                      icon: Icons.assignment_outlined,
                      value: '2',
                      label: context.tr.totalSpReceivedUpper,
                    ),

                    SizedBox(height: 15.w),

                    // Filter: dropdown jenis & status (Overlay Mingda Pattern)
                    Row(
                      children: [
                        Expanded(
                          child: WarningLetterTypeFilterDropdown(
                            selected: _selectedType,
                            onChanged: (val) {
                              setState(() => _selectedType = val);
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: WarningLetterStatusFilterDropdown(
                            selected: _selectedStatus,
                            onChanged: (val) {
                              setState(() => _selectedStatus = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.w),

                    // Tombol Cari & Reset (Mingda Corporate Styling)
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: context.tr.search,
                            icon: Icons.search_rounded,
                            isPrimary: true,
                            onTap: _applySearch,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _ActionButton(
                            label: context.tr.reset,
                            icon: Icons.refresh_rounded,
                            isPrimary: false,
                            onTap: _resetFilters,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.w),

                    // List surat peringatan atau Empty State
                    if (filteredList.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 36.w,
                          horizontal: 20.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14.w),
                          border: Border.all(color: Colors.white, width: 1.5.w),
                          boxShadow: [AppShadows.shadow094],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 40.w,
                              color: const Color(0xFF94A3B8),
                            ),
                            SizedBox(height: 10.w),
                            Text(
                              context.tr.noMatchingSpFound,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.w),
                            Text(
                              context.tr.noMatchingSpSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...filteredList.map((warning) => Padding(
                            padding: EdgeInsets.only(bottom: 12.w),
                            child: WarningLetterCard(
                              item: warning,
                              onTap: () {},
                              onDownload: () => _handleDownload(warning),
                            ),
                          )),

                    SizedBox(height: 16.w),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: [AppShadows.shadow094],
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                color: const Color(0xFFCCFBF1),
                width: 1.w,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: 22.w,
              color: const Color(0xFF0D9488),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.w,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.4,
                    height: 1.1,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                SizedBox(height: 3.w),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10.w,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        gradient: isPrimary
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.filterGradientStart,
                  AppColors.filterGradientEnd,
                ],
              )
            : null,
        color: isPrimary ? null : AppColors.white,
        border: Border.all(
          color: isPrimary
              ? AppColors.white.withValues(alpha: 0.45)
              : Colors.white,
          width: 1.5.w,
        ),
        boxShadow: [AppShadows.shadow094],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.w),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16.w,
                color: isPrimary ? AppColors.white : AppColors.filterSlateIcon,
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isPrimary ? AppColors.white : AppColors.filterSlateIcon,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
