import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/work_leave/presentation/widgets/work_leave_stat_card.dart';

Color _statusDotColor(WorkLeaveStatType status) {
  switch (status) {
    case WorkLeaveStatType.disetujui:
      return AppColors.filterStatusGreen;
    case WorkLeaveStatType.menunggu:
      return AppColors.filterStatusAmber;
    case WorkLeaveStatType.ditolak:
      return AppColors.filterStatusRed;
    case WorkLeaveStatType.cutiTerpakai:
      return AppColors.filterStatusPurple;
  }
}

String _statusLabel(WorkLeaveStatType status, BuildContext context) {
  switch (status) {
    case WorkLeaveStatType.disetujui:
      return context.tr.leaveStatApproved;
    case WorkLeaveStatType.menunggu:
      return context.tr.leaveStatPending;
    case WorkLeaveStatType.ditolak:
      return context.tr.leaveStatRejected;
    case WorkLeaveStatType.cutiTerpakai:
      return context.tr.leaveStatUsed;
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  WORK LEAVE STATUS FILTER DROPDOWN (Matches History Attendance Standards)
// ═══════════════════════════════════════════════════════════════════════════════
class WorkLeaveStatusFilterDropdown extends StatefulWidget {
  final WorkLeaveStatType? selected;
  final ValueChanged<WorkLeaveStatType?> onChanged;

  const WorkLeaveStatusFilterDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<WorkLeaveStatusFilterDropdown> createState() =>
      _WorkLeaveStatusFilterDropdownState();
}

class _WorkLeaveStatusFilterDropdownState
    extends State<WorkLeaveStatusFilterDropdown> {
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
            child: _WorkLeaveStatusPanel(
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
    if (mounted) {
      setState(() => _isOpen = false);
    }
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
        height: 44.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [AppShadows.shadow094],
          color: Colors.white,
          border: isActive
              ? Border.all(
                  color: AppColors.filterTealAccent,
                  width: 1.5.w,
                )
              : null,
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
                widget.selected != null
                    ? _statusLabel(widget.selected!, context)
                    : context.tr.allApplications,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.filterTealAccent
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              isActive
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 20.w,
              color: isActive
                  ? AppColors.filterTealAccent
                  : const Color(0xFF64748B),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkLeaveStatusPanel extends StatelessWidget {
  final WorkLeaveStatType? selected;
  final ValueChanged<WorkLeaveStatType?> onSelect;

  const _WorkLeaveStatusPanel({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = WorkLeaveStatType.values;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [
          AppShadows.shadow094,
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Semua Pengajuan" row
          _buildSemuaRow(context),
          SizedBox(height: 8.w),
          // 2x2 grid of statuses
          ...List.generate(2, (row) {
            return Padding(
              padding: EdgeInsets.only(bottom: row < 1 ? 6.w : 0),
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
                                  _statusLabel(status, context),
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
                                  overflow: TextOverflow.ellipsis,
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

  Widget _buildSemuaRow(BuildContext context) {
    final isSelected = selected == null;
    return GestureDetector(
      onTap: () => onSelect(null),
      child: Container(
        height: 36.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: isSelected
              ? AppColors.filterFrostedTealBg
              : AppColors.filterSlateBg,
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
                color: isSelected
                    ? AppColors.filterTealAccent
                    : AppColors.filterStatusGreen,
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
                context.tr.allApplications,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.filterTealAccent
                      : AppColors.filterItemText,
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

class _OverlayDismiss extends StatelessWidget {
  final VoidCallback onDismiss;
  final Widget child;

  const _OverlayDismiss({required this.onDismiss, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
