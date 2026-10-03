import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/widgets/mingda_date_picker_dialog.dart';
import 'package:mingda_app/features/work_leave/presentation/blocs/work_leave_bloc.dart';

/// Modal Bottom Sheet Formulir Pengajuan Cuti & Izin
/// Sepenuhnya selaras dengan Dokumen API Mingda (POST /mobile/v1/leave)
/// Dilengkapi Safe Testing Mode (tanpa menembak database production)
class WorkLeaveFormSheet extends StatefulWidget {
  const WorkLeaveFormSheet({super.key});

  static Future<void> show(BuildContext context) {
    final workLeaveBloc = context.read<WorkLeaveBloc>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => BlocProvider.value(
        value: workLeaveBloc,
        child: const WorkLeaveFormSheet(),
      ),
    );
  }

  @override
  State<WorkLeaveFormSheet> createState() => _WorkLeaveFormSheetState();
}

class _WorkLeaveFormSheetState extends State<WorkLeaveFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  // Field nilai sesuai spesifikasi API Mingda
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
        return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
      case AppLanguage.zh:
        return '${date.year}年${date.month.toString().padLeft(2, '0')}月${date.day.toString().padLeft(2, '0')}日';
      case AppLanguage.id:
        const months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
          'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
        ];
        return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
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
          {'name': 'surat_keterangan_dokter.pdf', 'size': '1.2 MB', 'icon': Icons.picture_as_pdf_rounded},
          {'name': 'bukti_resep_obat.jpg', 'size': '850 KB', 'icon': Icons.image_rounded},
          {'name': 'surat_undangan_resmi.pdf', 'size': '620 KB', 'icon': Icons.picture_as_pdf_rounded},
          {'name': 'dokumen_pendukung_izin.pdf', 'size': '430 KB', 'icon': Icons.description_rounded},
        ];

        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.w, 18.w, 24.w),
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
              SizedBox(height: 14.w),
              Text(
                'Pilih Berkas Lampiran (Mode Simulasi)',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.w),
              Text(
                'Pilih berkas pengujian untuk disimulasikan pada form',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11.5.sp,
                  color: const Color(0xFF64748B),
                ),
              ),
              SizedBox(height: 12.w),
              ...mockFiles.map((file) {
                return Material(
                  color: Colors.transparent,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
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
                        fontSize: 12.5.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      file['size'] as String,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5.sp,
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

    // Validasi aturan bisnis Mingda API: Lampiran wajib bila izin sakit
    if (_selectedLeaveType == 'sakit' && (_selectedAttachmentName == null || _selectedAttachmentName!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Untuk izin sakit, surat dokter / bukti medis wajib dilampirkan.',
            style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.sp),
          ),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 18.w),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Pengajuan cuti berhasil dibuat! (Status: Menunggu)',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFF0F766E),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
                    style: TextStyle(fontFamily: 'Inter', fontSize: 12.5.sp),
                  ),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              );
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 12.w, 18.w, 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle Bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                    ),
                  ),

                  SizedBox(height: 14.w),

                  // Header Title & Close Button
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Formulir Pengajuan Cuti / Izin',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2.w),
                            Text(
                              'Lengkapi formulir sesuai data pengajuan Anda',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          size: 20.w,
                          color: const Color(0xFF64748B),
                        ),
                        splashRadius: 18.w,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.w),

                  // 🛡️ Banner Safe Testing Mode (Production Guard)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 9.w,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4), // Emerald 50
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFFA7F3D0), // Emerald 200
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          size: 17.w,
                          color: const Color(0xFF059669),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Pengujian Aman (Production Guard Aktif)',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF047857),
                                ),
                              ),
                              SizedBox(height: 2.w),
                              Text(
                                'Form ini memproses data pengujian secara lokal tanpa mengirimkan perubahan ke database live production.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF065F46),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.w),

                  // ================= FIELD 1: JENIS PENGAJUAN (leave_type) =================
                  _buildSectionLabel('Jenis Pengajuan *'),
                  SizedBox(height: 6.w),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTypeOption(
                          type: 'cuti',
                          label: 'Cuti Tahunan',
                          icon: Icons.event_available_rounded,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildTypeOption(
                          type: 'izin',
                          label: 'Izin Kerja',
                          icon: Icons.assignment_rounded,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _buildTypeOption(
                          type: 'sakit',
                          label: 'Izin Sakit',
                          icon: Icons.medical_services_rounded,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.w),

                  // ================= FIELD 2: RENTANG TANGGAL (start_date & end_date) =================
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Tanggal Mulai *'),
                            SizedBox(height: 6.w),
                            _buildDateField(
                              date: _startDate,
                              onTap: () => _pickDate(isStart: true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('Tanggal Selesai *'),
                            SizedBox(height: 6.w),
                            _buildDateField(
                              date: _endDate,
                              onTap: () => _pickDate(isStart: false),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.w),

                  // Durasi Hari Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13.w,
                          color: const Color(0xFF64748B),
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          'Durasi: $_durationDays Hari',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.w),

                  // ================= FIELD 3: ALASAN PENGAJUAN (reason) =================
                  _buildSectionLabel('Alasan Pengajuan *'),
                  SizedBox(height: 6.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      boxShadow: [AppShadows.shadow094],
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller: _reasonController,
                      maxLines: 3,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.5.sp,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Tuliskan keterangan lengkap alasan cuti atau izin...',
                        hintStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                        contentPadding: EdgeInsets.all(12.w),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.w),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.w),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.w),
                          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.4),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Alasan pengajuan wajib diisi.';
                        }
                        if (value.trim().length < 5) {
                          return 'Keterangan minimal 5 karakter.';
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: 16.w),

                  // ================= FIELD 4: BERKAS LAMPIRAN (attachment) =================
                  Row(
                    children: [
                      Flexible(
                        child: _buildSectionLabel('Dokumen Pendukung / Surat Dokter'),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _selectedLeaveType == 'sakit' ? '(Wajib)' : '(Opsional)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: _selectedLeaveType == 'sakit'
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.w),
                  _buildAttachmentCard(),

                  SizedBox(height: 22.w),

                  // ================= ACTION BUTTONS =================
                  Row(
                    children: [
                      // Tombol Batal
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.w),
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                          ),
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      // Tombol Kirim Pengajuan
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 44.w,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0F766E),
                                Color(0xFF14B8A6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.w),
                            boxShadow: [AppShadows.shadow094],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: 8.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.send_rounded,
                                        size: 15.w,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 6.w),
                                      Flexible(
                                        child: Text(
                                          'Kirim Pengajuan',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
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
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTypeOption({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedLeaveType == type;

    return InkWell(
      onTap: () => setState(() => _selectedLeaveType = type),
      borderRadius: BorderRadius.circular(10.w),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 6.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0FDFA) : Colors.white,
          borderRadius: BorderRadius.circular(10.w),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [AppShadows.shadow094],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20.w,
              color: isSelected ? const Color(0xFF0D9488) : const Color(0xFF64748B),
            ),
            SizedBox(height: 5.w),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10.5.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFF0F766E) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Container(
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
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.w),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  size: 16.w,
                  color: const Color(0xFF0D9488),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _formatDisplayDate(date),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentCard() {
    final hasAttachment = _selectedAttachmentName != null && _selectedAttachmentName!.isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showAttachmentPicker,
          borderRadius: BorderRadius.circular(10.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: hasAttachment ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
              ),
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: hasAttachment ? const Color(0xFFF0FDFA) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    hasAttachment ? Icons.attach_file_rounded : Icons.upload_file_rounded,
                    size: 18.w,
                    color: hasAttachment ? const Color(0xFF0D9488) : const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasAttachment ? _selectedAttachmentName! : 'Pilih Berkas Lampiran',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.5.sp,
                          fontWeight: hasAttachment ? FontWeight.w600 : FontWeight.w400,
                          color: hasAttachment ? AppColors.textPrimary : const Color(0xFF94A3B8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        hasAttachment ? 'Ketuk untuk mengganti berkas' : 'Format PDF, JPG (Maks. 2MB)',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.5.sp,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasAttachment)
                  IconButton(
                    onPressed: () => setState(() => _selectedAttachmentName = null),
                    icon: Icon(
                      Icons.cancel_rounded,
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
    );
  }
}
