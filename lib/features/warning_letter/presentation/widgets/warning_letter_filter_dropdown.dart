import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

enum WarningLetterType {
  sp1('SP-1', 'SP 1'),
  sp2('SP-2', 'SP 2'),
  sp3('SP-3', 'SP 3');

  final String code;
  final String label;
  const WarningLetterType(this.code, this.label);
}

enum WarningLetterStatus {
  aktif('Aktif'),
  selesai('Selesai');

  final String label;
  const WarningLetterStatus(this.label);
}

// ═══════════════════════════════════════════════════════════════════════════════
//  WARNING LETTER TYPE FILTER DROPDOWN (Matches Mingda App Overlay Pattern)
// ═══════════════════════════════════════════════════════════════════════════════
class WarningLetterTypeFilterDropdown extends StatefulWidget {
  final WarningLetterType? selected;
  final ValueChanged<WarningLetterType?> onChanged;

  const WarningLetterTypeFilterDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<WarningLetterTypeFilterDropdown> createState() =>
      _WarningLetterTypeFilterDropdownState();
}

class _WarningLetterTypeFilterDropdownState
    extends State<WarningLetterTypeFilterDropdown> {
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
          top: offset.dy + size.height + 6.w,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: _TypeSelectionPanel(
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

    return GestureDetector(
      key: _triggerKey,
      onTap: _toggle,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [AppShadows.shadow094],
          color: Colors.white,
          border: Border.all(
            color: isActive ? AppColors.filterTealAccent : Colors.white,
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            // Mini badge indicator
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: widget.selected != null
                    ? AppColors.filterFrostedTealBg
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(
                  color: widget.selected != null
                      ? AppColors.filterFrostedTealBorder
                      : const Color(0xFFE2E8F0),
                  width: 1.w,
                ),
              ),
              child: Text(
                widget.selected != null ? widget.selected!.code : 'ALL',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.selected != null
                      ? AppColors.filterTealAccent
                      : const Color(0xFF64748B),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                widget.selected != null
                    ? widget.selected!.label
                    : context.tr.allWord,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5.sp,
                  fontWeight: isActive || widget.selected != null
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: isActive
                      ? AppColors.filterTealAccent
                      : (widget.selected != null
                          ? AppColors.textPrimary
                          : const Color(0xFF64748B)),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isActive
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 18.w,
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

class _TypeSelectionPanel extends StatelessWidget {
  final WarningLetterType? selected;
  final ValueChanged<WarningLetterType?> onSelect;

  const _TypeSelectionPanel({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final types = WarningLetterType.values;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: [
          AppShadows.shadow094,
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Semua" option
          _buildItem(
            label: context.tr.allWord,
            badge: 'ALL',
            isSelected: selected == null,
            onTap: () => onSelect(null),
          ),
          SizedBox(height: 6.w),
          ...types.map((type) {
            return Padding(
              padding: EdgeInsets.only(bottom: type != types.last ? 6.w : 0),
              child: _buildItem(
                label: type.label,
                badge: type.code,
                isSelected: selected == type,
                onTap: () => onSelect(type),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String label,
    required String badge,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.white : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4.w),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? AppColors.filterTealAccent
                      : const Color(0xFF64748B),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.filterTealAccent
                      : AppColors.filterItemText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 14.w, color: AppColors.filterTealAccent),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  WARNING LETTER STATUS FILTER DROPDOWN (Matches Mingda App Overlay Pattern)
// ═══════════════════════════════════════════════════════════════════════════════
class WarningLetterStatusFilterDropdown extends StatefulWidget {
  final WarningLetterStatus? selected;
  final ValueChanged<WarningLetterStatus?> onChanged;

  const WarningLetterStatusFilterDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  State<WarningLetterStatusFilterDropdown> createState() =>
      _WarningLetterStatusFilterDropdownState();
}

class _WarningLetterStatusFilterDropdownState
    extends State<WarningLetterStatusFilterDropdown> {
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
          top: offset.dy + size.height + 6.w,
          width: size.width,
          child: Material(
            color: Colors.transparent,
            child: _StatusSelectionPanel(
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

    return GestureDetector(
      key: _triggerKey,
      onTap: _toggle,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          boxShadow: [AppShadows.shadow094],
          color: Colors.white,
          border: Border.all(
            color: isActive ? AppColors.filterTealAccent : Colors.white,
            width: 1.5.w,
          ),
        ),
        child: Row(
          children: [
            // Status dot indicator
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.selected != null
                    ? (widget.selected == WarningLetterStatus.aktif
                        ? const Color(0xFF0D9488)
                        : const Color(0xFF64748B))
                    : (isActive
                        ? AppColors.filterTealAccent
                        : const Color(0xFF0D9488)),
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
                    ? (widget.selected == WarningLetterStatus.aktif
                        ? context.tr.statActive
                        : context.tr.statCompleted)
                    : context.tr.selectStatus,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.5.sp,
                  fontWeight: isActive || widget.selected != null
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: isActive
                      ? AppColors.filterTealAccent
                      : (widget.selected != null
                          ? AppColors.textPrimary
                          : const Color(0xFF64748B)),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              isActive
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 18.w,
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

class _StatusSelectionPanel extends StatelessWidget {
  final WarningLetterStatus? selected;
  final ValueChanged<WarningLetterStatus?> onSelect;

  const _StatusSelectionPanel({
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = WarningLetterStatus.values;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: [
          AppShadows.shadow094,
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.08),
            offset: const Offset(0, 4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Semua Status" option
          _buildItem(
            label: context.tr.allStatuses,
            dotColor: const Color(0xFF0D9488),
            isSelected: selected == null,
            onTap: () => onSelect(null),
          ),
          SizedBox(height: 6.w),
          ...statuses.map((status) {
            final dotColor = status == WarningLetterStatus.aktif
                ? const Color(0xFF0D9488)
                : const Color(0xFF64748B);
            final statusLabel = status == WarningLetterStatus.aktif
                ? context.tr.statActive
                : context.tr.statCompleted;
            return Padding(
              padding:
                  EdgeInsets.only(bottom: status != statuses.last ? 6.w : 0),
              child: _buildItem(
                label: statusLabel,
                dotColor: dotColor,
                isSelected: selected == status,
                onTap: () => onSelect(status),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String label,
    required Color dotColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.filterTealAccent
                      : AppColors.filterItemText,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Icon(Icons.check_rounded, size: 14.w, color: AppColors.filterTealAccent),
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
