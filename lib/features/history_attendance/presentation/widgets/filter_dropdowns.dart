import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/attendance_enum.dart';
import 'package:mingda_app/features/history_attendance/domain/enum/month_enum.dart';

// ─── Short month labels for grid ─────────────────────────────────────────────
const _monthShortLabels = [
  'Jan', 'Feb', 'Mar', 'Apr',
  'Mei', 'Jun', 'Jul', 'Ags',
  'Sep', 'Okt', 'Nov', 'Des',
];

// ─── Status dot colors ──────────────────────────────────────────────────────
Color _statusDotColor(AttendanceEnum status) {
  switch (status) {
    case AttendanceEnum.Hadir:
      return AppColors.filterStatusGreen;
    case AttendanceEnum.Terlambat:
      return AppColors.filterStatusAmber;
    case AttendanceEnum.Alpha:
      return AppColors.filterStatusRed;
    case AttendanceEnum.Izin:
      return AppColors.filterStatusBlue;
    case AttendanceEnum.Cuti:
      return AppColors.filterStatusPurple;
    case AttendanceEnum.Sakit:
      return AppColors.filterStatusOrange;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  MONTH FILTER DROPDOWN  (4×3 Grid + "Semua Bulan")
// ═══════════════════════════════════════════════════════════════════════════════
class MonthFilterDropdown extends StatefulWidget {
  final MonthEnum? selected;
  final ValueChanged<MonthEnum?> onChanged;

  const MonthFilterDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<MonthFilterDropdown> createState() => _MonthFilterDropdownState();
}

class _MonthFilterDropdownState extends State<MonthFilterDropdown> {
  final _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _OverlayDismiss(
        onDismiss: _close,
        child: Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 8.w,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: _MonthPanel(
              selected: widget.selected,
              onSelect: (value) {
                _close();
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isOpen;
    return GestureDetector(
      key: _triggerKey,
      onTap: _toggle,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: isActive ? AppColors.filterFrostedTealBg : AppColors.filterSlateBg,
          border: Border.all(
            color: isActive ? AppColors.filterTealAccent : AppColors.filterSlateBorder,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14.w,
              color: isActive ? AppColors.filterTealAccent : AppColors.filterSlateIcon,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.selected?.name ?? 'Semua Bulan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.filterTealAccent : AppColors.filterDarkText,
                ),
              ),
            ),
            Icon(
              isActive ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: isActive ? AppColors.filterTealAccent : AppColors.filterSlateIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthPanel extends StatelessWidget {
  final MonthEnum? selected;
  final ValueChanged<MonthEnum?> onSelect;

  const _MonthPanel({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final currentMonthIndex = DateTime.now().month - 1; // 0-based

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: AppColors.filterSlateBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Semua Bulan" row
          _buildSemuaBulanRow(),
          SizedBox(height: 8.w),
          // 4×3 grid
          ...List.generate(3, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: row < 2 ? 6.w : 0),
              child: Row(
                children: List.generate(4, (col) {
                  final index = row * 4 + col;
                  final month = MonthEnum.values[index];
                  final isSelected = selected == month;
                  final isCurrentMonth = index == currentMonthIndex && selected == null;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: col < 3 ? 8.w : 0),
                      child: GestureDetector(
                        onTap: () => onSelect(month),
                        child: Container(
                          height: 34.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: (isSelected || isCurrentMonth)
                                ? AppColors.filterTealAccent
                                : AppColors.filterSlateBg,
                          ),
                          child: Text(
                            _monthShortLabels[index],
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.5.sp,
                              fontWeight: (isSelected || isCurrentMonth)
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: (isSelected || isCurrentMonth)
                                  ? AppColors.white
                                  : AppColors.filterItemText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSemuaBulanRow() {
    final isSelected = selected == null;
    return GestureDetector(
      onTap: () => onSelect(null),
      child: Container(
        height: 34.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: isSelected ? AppColors.filterFrostedTealBg : AppColors.filterSlateBg,
          border: isSelected
              ? Border.all(color: AppColors.filterFrostedTealBorder, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Semua Bulan',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.filterTealAccent : AppColors.filterItemText,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 14.w, color: AppColors.filterTealAccent),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  YEAR FILTER DROPDOWN  (Vertical list)
// ═══════════════════════════════════════════════════════════════════════════════
class YearFilterDropdown extends StatefulWidget {
  final int selected;
  final List<int> years;
  final ValueChanged<int?> onChanged;

  const YearFilterDropdown({
    super.key,
    required this.selected,
    required this.years,
    required this.onChanged,
  });

  @override
  State<YearFilterDropdown> createState() => _YearFilterDropdownState();
}

class _YearFilterDropdownState extends State<YearFilterDropdown> {
  final _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _OverlayDismiss(
        onDismiss: _close,
        child: Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 8.w,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: _YearPanel(
              selected: widget.selected,
              years: widget.years,
              onSelect: (value) {
                _close();
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isOpen;
    return GestureDetector(
      key: _triggerKey,
      onTap: _toggle,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: AppColors.filterFrostedTealBg,
          border: Border.all(
            color: isActive ? AppColors.filterTealAccent : AppColors.filterFrostedTealBorder,
            width: isActive ? 1.8 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 14.w,
              color: AppColors.filterTealAccent,
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                widget.selected.toString(),
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.filterTealAccent,
                ),
              ),
            ),
            Icon(
              isActive ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: AppColors.filterTealAccent,
            ),
          ],
        ),
      ),
    );
  }
}

class _YearPanel extends StatelessWidget {
  final int selected;
  final List<int> years;
  final ValueChanged<int> onSelect;

  const _YearPanel({
    required this.selected,
    required this.years,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: AppColors.filterSlateBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: years.map((year) {
          final isSelected = year == selected;
          return Padding(
            padding: EdgeInsets.only(bottom: year != years.last ? 4.w : 0),
            child: GestureDetector(
              onTap: () => onSelect(year),
              child: Container(
                height: 36.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  color: isSelected ? AppColors.filterTealAccent : AppColors.filterSlateBg,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      year.toString(),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.white
                            : (year == DateTime.now().year
                                ? AppColors.filterItemText
                                : AppColors.filterSlateIcon),
                      ),
                    ),
                    if (isSelected) ...[
                      SizedBox(width: 8.w),
                      Icon(Icons.check, size: 12.w, color: AppColors.white),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  STATUS FILTER DROPDOWN  (2×3 Grid + "Semua Kehadiran")
// ═══════════════════════════════════════════════════════════════════════════════
class StatusFilterDropdown extends StatefulWidget {
  final AttendanceEnum? selected;
  final ValueChanged<AttendanceEnum?> onChanged;

  const StatusFilterDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<StatusFilterDropdown> createState() => _StatusFilterDropdownState();
}

class _StatusFilterDropdownState extends State<StatusFilterDropdown> {
  final _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggle() {
    if (_isOpen) {
      _close();
    } else {
      _open();
    }
  }

  void _open() {
    final renderBox =
        _triggerKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _OverlayDismiss(
        onDismiss: _close,
        child: Positioned(
          left: offset.dx,
          top: offset.dy + size.height + 8.w,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: _StatusPanel(
              selected: widget.selected,
              onSelect: (value) {
                _close();
                widget.onChanged(value);
              },
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _isOpen;
    final dotColor = widget.selected != null
        ? _statusDotColor(widget.selected!)
        : (isActive ? AppColors.filterTealAccent : AppColors.filterStatusGreen);

    return GestureDetector(
      key: _triggerKey,
      onTap: _toggle,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: isActive ? AppColors.filterFrostedTealBg : AppColors.filterSlateBg,
          border: Border.all(
            color: isActive ? AppColors.filterTealAccent : AppColors.filterSlateBorder,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Status dot
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
              child: Center(
                child: Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.selected?.name ?? 'Semua Kehadiran',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? AppColors.filterTealAccent : AppColors.filterDarkText,
                ),
              ),
            ),
            Icon(
              isActive ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 18.w,
              color: isActive ? AppColors.filterTealAccent : AppColors.filterSlateIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final AttendanceEnum? selected;
  final ValueChanged<AttendanceEnum?> onSelect;

  const _StatusPanel({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: AppColors.filterSlateBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.10),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Semua Kehadiran" row
          _buildSemuaRow(),
          SizedBox(height: 8.w),
          // 2×3 grid of statuses
          ...List.generate(3, (row) {
            final statuses = AttendanceEnum.values;
            return Padding(
              padding: EdgeInsets.only(bottom: row < 2 ? 6.w : 0),
              child: Row(
                children: List.generate(2, (col) {
                  final index = row * 2 + col;
                  final status = statuses[index];
                  final isSelected = selected == status;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: col == 0 ? 8.w : 0),
                      child: GestureDetector(
                        onTap: () => onSelect(status),
                        child: Container(
                          height: 36.w,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: isSelected
                                ? AppColors.filterFrostedTealBg
                                : AppColors.filterSlateBg,
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.filterFrostedTealBorder,
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _statusDotColor(status),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  status.name,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11.5.sp,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.filterTealAccent
                                        : AppColors.filterItemText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSemuaRow() {
    final isSelected = selected == null;
    return GestureDetector(
      onTap: () => onSelect(null),
      child: Container(
        height: 36.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: isSelected ? AppColors.filterFrostedTealBg : AppColors.filterSlateBg,
          border: isSelected
              ? Border.all(color: AppColors.filterFrostedTealBorder, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 9.w,
              height: 9.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.filterTealAccent : AppColors.filterStatusGreen,
              ),
              child: Center(
                child: Container(
                  width: 3.6.w,
                  height: 3.6.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Semua Kehadiran',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.filterTealAccent : AppColors.filterItemText,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 14.w, color: AppColors.filterTealAccent),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  OVERLAY DISMISS HELPER
// ═══════════════════════════════════════════════════════════════════════════════
class _OverlayDismiss extends StatelessWidget {
  final VoidCallback onDismiss;
  final Widget child;

  const _OverlayDismiss({required this.onDismiss, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Transparent barrier that catches taps outside the dropdown
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.opaque,
            child: const ColoredBox(color: Colors.transparent),
          ),
        ),
        child,
      ],
    );
  }
}
