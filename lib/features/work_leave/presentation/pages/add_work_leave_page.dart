import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/widgets/mingda_date_picker_dialog.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';

class AddWorkLeavePage extends StatefulWidget {
  const AddWorkLeavePage({super.key});

  @override
  State<AddWorkLeavePage> createState() => _AddWorkLeavePageState();
}

class _AddWorkLeavePageState extends State<AddWorkLeavePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String _selectedLeaveType = 'cuti'; // 'cuti' | 'izin' | 'sakit'
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String? _selectedAttachmentName;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  int get _durationDays {
    final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
    final end = DateTime(_endDate.year, _endDate.month, _endDate.day);
    final diff = end.difference(start).inDays + 1;
    return diff > 0 ? diff : 1;
  }

  String _formatDisplayDate(DateTime date, [AppLanguage? language]) {
    final lang = language ?? (mounted ? context.currentLanguage : AppLanguage.id);
    switch (lang) {
      case AppLanguage.en:
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        return '${date.day} ${months[date.month - 1]} ${date.year}';
      case AppLanguage.zh:
        return '${date.year}年${date.month}月${date.day}日';
      case AppLanguage.id:
        const months = [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
        ];
        return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  String _formatApiDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final first = isStart ? DateTime(2025) : _startDate;
    final last = DateTime(2030);

    final picked = await showMingdaDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: last,
      title: isStart
          ? context.tr.selectStartDateUpper
          : context.tr.selectEndDateUpper,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showAttachmentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final mockFiles = [
          {
            'name': 'surat_keterangan_dokter.pdf',
            'size': '1.2 MB',
            'icon': Icons.picture_as_pdf_rounded,
          },
          {
            'name': 'bukti_resep_obat.jpg',
            'size': '850 KB',
            'icon': Icons.image_rounded,
          },
          {
            'name': 'surat_undangan_resmi.pdf',
            'size': '620 KB',
            'icon': Icons.picture_as_pdf_rounded,
          },
          {
            'name': 'dokumen_pendukung_izin.pdf',
            'size': '430 KB',
            'icon': Icons.description_rounded,
          },
        ];

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 14.w, 20.w, 28.w),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                ),
              ),
              SizedBox(height: 16.w),
              Text(
                context.tr.selectAttachmentFile,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15.w,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                context.tr.attachmentSub,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.w,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 14.w),
              ...mockFiles.map((file) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.w,
                    ),
                    leading: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        file['icon'] as IconData,
                        size: 20.w,
                        color: const Color(0xFF0D9488),
                      ),
                    ),
                    title: Text(
                      file['name'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.w,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      file['size'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.w,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedAttachmentName = file['name'] as String;
                      });
                      Navigator.pop(ctx);
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      );
      },
    );
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedLeaveType == 'sakit' &&
        (_selectedAttachmentName == null || _selectedAttachmentName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.doctorCertWarning,
            style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.w),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final startDateStr = _formatApiDate(_startDate);
    final endDateStr = _formatApiDate(_endDate);
    final reasonText = _reasonController.text.trim();

    context.read<WorkLeaveBloc>().add(
          WorkLeaveEventSubmitRequest(
            leaveType: _selectedLeaveType,
            startDate: startDateStr,
            endDate: endDateStr,
            reason: reasonText,
            attachmentPath: _selectedAttachmentName,
            onSuccess: (newEntity) {
              if (!mounted) return;
              setState(() => _isSubmitting = false);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 18.w,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          context.tr.leaveSubmitSuccess,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF0D9488),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            onError: (errorMessage) {
              if (!mounted) return;
              setState(() => _isSubmitting = false);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    errorMessage,
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.w),
                  ),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        shadowColor: AppColors.shadowAppBar,
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.tr.addLeaveFormTitle,
          style: AppTextStyles.inter16MediumPrimary,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= CARD 1: JENIS PENGAJUAN =================
                      _buildSectionTitle(context.tr.leaveTypeLabel),
                      SizedBox(height: 8.w),
                      _buildCardContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeSegment(
                                type: 'cuti',
                                label: context.tr.statAnnualLeave,
                                icon: Icons.event_available_rounded,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _buildTypeSegment(
                                type: 'izin',
                                label: context.tr.statPermission,
                                icon: Icons.assignment_turned_in_rounded,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: _buildTypeSegment(
                                type: 'sakit',
                                label: context.tr.statSick,
                                icon: Icons.health_and_safety_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.w),

                      // ================= CARD 2: RENTANG TANGGAL =================
                      _buildSectionTitle(context.tr.dateRange),
                      SizedBox(height: 8.w),
                      _buildCardContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateItem(
                                    label: context.tr.start,
                                    date: _startDate,
                                    onTap: () => _pickDate(isStart: true),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: _buildDateItem(
                                    label: context.tr.end,
                                    date: _endDate,
                                    onTap: () => _pickDate(isStart: false),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.w),
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: const Color(0xFFF1F5F9),
                            ),
                            SizedBox(height: 10.w),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 15.w,
                                        color: const Color(0xFF64748B),
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          context.tr.totalDuration,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.w,
                                            color: const Color(0xFF64748B),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    '$_durationDays ${context.tr.workingDays}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D9488),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 18.w),

                      // ================= CARD 3: ALASAN PENGAJUAN =================
                      _buildSectionTitle(context.tr.reasonLabel),
                      SizedBox(height: 8.w),
                      _buildCardContainer(
                        child: TextFormField(
                          controller: _reasonController,
                          maxLines: 4,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13.w,
                            color: AppColors.textPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: context.tr.reasonHint,
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.5.w,
                              color: const Color(0xFF94A3B8),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.tr.reasonRequired;
                            }
                            if (value.trim().length < 5) {
                              return context.tr.reasonMin5;
                            }
                            return null;
                          },
                        ),
                      ),

                      SizedBox(height: 18.w),

                      // ================= CARD 4: BERKAS LAMPIRAN =================
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6.w,
                        children: [
                          _buildSectionTitle(context.tr.supportingDocuments),
                          Text(
                            _selectedLeaveType == 'sakit'
                                ? context.tr.doctorCertRequired
                                : context.tr.optional,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11.w,
                              fontWeight: FontWeight.w500,
                              color: _selectedLeaveType == 'sakit'
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),
                      _buildCardContainer(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showAttachmentPicker,
                            borderRadius: BorderRadius.circular(8.r),
                            child: Row(
                              children: [
                                Container(
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    color: _selectedAttachmentName != null
                                        ? const Color(0xFF0D9488)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    _selectedAttachmentName != null
                                        ? Icons.file_present_rounded
                                        : Icons.upload_file_rounded,
                                    size: 20.w,
                                    color: _selectedAttachmentName != null
                                        ? Colors.white
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedAttachmentName ??
                                            context.tr.selectAttachmentFile,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13.w,
                                          fontWeight:
                                              _selectedAttachmentName != null
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                          color:
                                              _selectedAttachmentName != null
                                                  ? AppColors.textPrimary
                                                  : const Color(0xFF94A3B8),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 3.w),
                                      Text(
                                        _selectedAttachmentName != null
                                            ? context.tr.tapToChangeFile
                                            : context.tr.attachmentSub,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.w,
                                          color: const Color(0xFF94A3B8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_selectedAttachmentName != null)
                                  IconButton(
                                    onPressed: () => setState(
                                      () => _selectedAttachmentName = null,
                                    ),
                                    icon: Icon(
                                      Icons.close_rounded,
                                      size: 18.w,
                                      color: const Color(0xFF94A3B8),
                                    ),
                                    splashRadius: 16.w,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.w),
                    ],
                  ),
                ),
              ),
            ),

            // ================= STICKY BOTTOM SUBMIT BAR =================
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [AppShadows.shadow094],
              ),
              child: Container(
                width: double.infinity,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF0F766E), // Teal 700
                      Color(0xFF14B8A6), // Teal 500
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.w),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.45),
                    width: 1.w,
                  ),
                  boxShadow: [AppShadows.shadow094],
                ),
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send_rounded,
                              size: 16.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              context.tr.submitApplication,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.w,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13.w,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: [AppShadows.shadow094],
      ),
      child: child,
    );
  }

  Widget _buildTypeSegment({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedLeaveType == type;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedLeaveType = type),
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(vertical: 11.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0D9488) : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20.w,
                color: isSelected ? Colors.white : const Color(0xFF64748B),
              ),
              SizedBox(height: 5.w),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12.w,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateItem({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.w,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
            SizedBox(height: 4.w),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 14.w,
                  color: const Color(0xFF0D9488),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    _formatDisplayDate(date),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.w,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
