import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_item_card.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_stat_card.dart';

class WorkLeavePage extends StatefulWidget {
  const WorkLeavePage({super.key});

  @override
  State<WorkLeavePage> createState() => _WorkLeavePageState();
}

class _WorkLeavePageState extends State<WorkLeavePage> {
  WorkLeaveStatType? _selectedStat;
  final String _selectedMonth = 'Desember';
  final String _selectedYear = '2026';
  final String _selectedStatusDropdown = 'Semua Status';

  // Sample data pengajuan cuti & izin
  final List<Map<String, String>> _allLeaveItems = [
    {
      'title': 'Izin Sakit',
      'status': 'Disetujui',
      'startDate': '10 Apr 2026',
      'endDate': '11 Apr 2026',
      'category': 'disetujui',
    },
    {
      'title': 'Cuti Tahunan',
      'status': 'Menunggu',
      'startDate': '20 Apr 2026',
      'endDate': '23 Apr 2026',
      'category': 'menunggu',
    },
    {
      'title': 'Izin Keperluan Mendesak',
      'status': 'Ditolak',
      'startDate': '05 Apr 2026',
      'endDate': '05 Apr 2026',
      'category': 'ditolak',
    },
    {
      'title': 'Cuti Bersama',
      'status': 'Disetujui',
      'startDate': '01 Apr 2026',
      'endDate': '02 Apr 2026',
      'category': 'cutiTerpakai',
    },
  ];

  void _onStatCardTapped(WorkLeaveStatType type) {
    setState(() {
      if (_selectedStat == type) {
        _selectedStat = null;
      } else {
        _selectedStat = type;
      }
    });
  }

  List<Map<String, String>> get _filteredItems {
    if (_selectedStat == null) return _allLeaveItems;

    switch (_selectedStat!) {
      case WorkLeaveStatType.disetujui:
        return _allLeaveItems.where((i) => i['status'] == 'Disetujui').toList();
      case WorkLeaveStatType.menunggu:
        return _allLeaveItems.where((i) => i['status'] == 'Menunggu').toList();
      case WorkLeaveStatType.ditolak:
        return _allLeaveItems.where((i) => i['status'] == 'Ditolak').toList();
      case WorkLeaveStatType.cutiTerpakai:
        return _allLeaveItems.where((i) => i['title']!.toLowerCase().contains('cuti')).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.w),

              // ==================== 1. REKAP STATISTIK CUTI (GOJEK SOLID BADGE) ====================
              Row(
                children: [
                  Expanded(
                    child: WorkLeaveStatCard(
                      type: WorkLeaveStatType.disetujui,
                      value: '12',
                      isSelected: _selectedStat == WorkLeaveStatType.disetujui,
                      onTap: () => _onStatCardTapped(WorkLeaveStatType.disetujui),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: WorkLeaveStatCard(
                      type: WorkLeaveStatType.menunggu,
                      value: '5',
                      isSelected: _selectedStat == WorkLeaveStatType.menunggu,
                      onTap: () => _onStatCardTapped(WorkLeaveStatType.menunggu),
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
                      value: '1',
                      isSelected: _selectedStat == WorkLeaveStatType.ditolak,
                      onTap: () => _onStatCardTapped(WorkLeaveStatType.ditolak),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: WorkLeaveStatCard(
                      type: WorkLeaveStatType.cutiTerpakai,
                      value: '2',
                      isSelected: _selectedStat == WorkLeaveStatType.cutiTerpakai,
                      onTap: () => _onStatCardTapped(WorkLeaveStatType.cutiTerpakai),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 18.w),

              // ==================== 2. FILTER BULAN & TAHUN ====================
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _FilterDropdown(
                      value: _selectedMonth,
                      onTap: () {
                        // Dropdown selection hook
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 1,
                    child: _FilterDropdown(
                      value: _selectedYear,
                      onTap: () {
                        // Dropdown selection hook
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.w),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _FilterDropdown(
                      value: _selectedStatusDropdown,
                      onTap: () {
                        // Dropdown selection hook
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _FilterIconButton(
                    icon: Icons.sort_rounded,
                    onTap: () {},
                  ),
                  SizedBox(width: 10.w),
                  _FilterIconButton(
                    icon: Icons.refresh_rounded,
                    onTap: () {
                      setState(() {
                        _selectedStat = null;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 20.w),

              // ==================== 3. HEADER RIWAYAT PENGAJUAN ====================
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
                        'Riwayat Pengajuan Cuti',
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

              // ==================== 4. DAFTAR RIWAYAT PENGAJUAN ====================
              if (_filteredItems.isEmpty)
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
                        'Tidak ada pengajuan cuti pada filter ini',
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
                  itemCount: _filteredItems.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.w),
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return WorkLeaveItemCard(
                      title: item['title']!,
                      status: item['status']!,
                      startDate: item['startDate']!,
                      endDate: item['endDate']!,
                      onTap: () {},
                    );
                  },
                ),

              SizedBox(height: 24.w),
            ],
          ),
        ),
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
