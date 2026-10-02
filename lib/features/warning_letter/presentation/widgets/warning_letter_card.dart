import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

/// Data Model Surat Peringatan sesuai Dokumentasi REST API Mingda
/// (Endpoint: /mobile/v1/warning-letters/*)
class WarningLetterItemData {
  final int id;
  final String spNumber;
  final String spLevel;
  final String title;
  final String description;
  final String status;
  final String issuedDate;
  final String validUntil;
  final String? attachmentUrl;

  const WarningLetterItemData({
    required this.id,
    required this.spNumber,
    required this.spLevel,
    required this.title,
    required this.description,
    required this.status,
    required this.issuedDate,
    required this.validUntil,
    this.attachmentUrl,
  });

  bool get isActive {
    final lower = status.toLowerCase();
    return lower == 'active' || lower == 'aktif';
  }

  String get displayStatus {
    return isActive ? 'Aktif' : 'Selesai';
  }

  factory WarningLetterItemData.fromJson(Map<String, dynamic> json) {
    return WarningLetterItemData(
      id: json['id'] as int? ?? 0,
      spNumber: json['sp_number'] as String? ?? json['letter_number'] as String? ?? '-',
      spLevel: json['sp_level'] as String? ?? json['type'] as String? ?? 'SP 1',
      title: json['title'] as String? ?? '-',
      description: json['description'] as String? ?? json['reason'] as String? ?? '-',
      status: json['status'] as String? ?? 'active',
      issuedDate: json['issued_date'] as String? ?? json['date'] as String? ?? '-',
      validUntil: json['valid_until'] as String? ?? '-',
      attachmentUrl: json['attachment_url'] as String? ?? json['download_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sp_number': spNumber,
      'sp_level': spLevel,
      'title': title,
      'description': description,
      'status': status,
      'issued_date': issuedDate,
      'valid_until': validUntil,
      'attachment_url': attachmentUrl,
    };
  }
}

/// Kartu Surat Peringatan (Warning Letter)
/// Mengikuti Design System Mingda App & Anti-Rainbow Invariant:
/// - Base surface netral putih bersih (AppColors.white) dengan AppShadows.shadow094
/// - Left Accent Bar: Strip vertikal 4px (Deep Teal #0F766E untuk SP Aktif, Slate #94A3B8 untuk SP Selesai)
/// - Semantic Icon Box: Soft-mint container 38.w dengan semantic icon
/// - Status Badge: Signature Mingda Teal Gradient (#0F766E -> #14B8A6) untuk status AKTIF
/// - Action Button: Soft-Mint button elegan (#F0FDFA)
class WarningLetterCard extends StatelessWidget {
  final WarningLetterItemData item;
  final VoidCallback? onTap;
  final VoidCallback? onDownload;

  const WarningLetterCard({
    super.key,
    required this.item,
    this.onTap,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = item.isActive;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: Colors.white,
          width: 1.5.w,
        ),
        boxShadow: [
          AppShadows.shadow094,
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ─── 1. Left Accent Bar (Teal untuk Aktif, Slate untuk Selesai) ───
              Container(
                width: 4.w,
                color: isActive
                    ? const Color(0xFF0F766E)
                    : const Color(0xFF94A3B8),
              ),

              // ─── 2. Card Content Body ───
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onTap,
                    splashColor: const Color(0xFF0D9488).withValues(alpha: 0.08),
                    highlightColor: const Color(0xFF0D9488).withValues(alpha: 0.04),
                    child: Padding(
                      padding: EdgeInsets.all(14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ─── HEADER: Icon Box + Title & SP Number + Gradient Status Badge ───
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Semantic Icon Box
                              Container(
                                width: 38.w,
                                height: 38.w,
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFFF0FDFA)
                                      : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(8.w),
                                  border: Border.all(
                                    color: isActive
                                        ? const Color(0xFFCCFBF1)
                                        : const Color(0xFFE2E8F0),
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    isActive
                                        ? Icons.assignment_late_outlined
                                        : Icons.assignment_turned_in_outlined,
                                    size: 20.w,
                                    color: isActive
                                        ? const Color(0xFF0D9488)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ),

                              SizedBox(width: 10.w),

                              // Title, Level Chip & SP Number
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.charcoalSlate,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.w),
                                    Row(
                                      children: [
                                        // Level Chip (SP 1 / SP 2 / SP 3)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.w,
                                            vertical: 2.w,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isActive
                                                ? const Color(0xFFE6FFFA)
                                                : const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(4.w),
                                            border: Border.all(
                                              color: isActive
                                                  ? const Color(0xFF99F6E4)
                                                  : const Color(0xFFE2E8F0),
                                              width: 0.8.w,
                                            ),
                                          ),
                                          child: Text(
                                            item.spLevel,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w700,
                                              color: isActive
                                                  ? const Color(0xFF0F766E)
                                                  : const Color(0xFF64748B),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Expanded(
                                          child: Text(
                                            item.spNumber,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xFF64748B),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8.w),

                              // Status Badge (Aktif = Signature Mingda Gradient, Selesai = Neutral Slate)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: isActive ? 9.w : 8.w,
                                  vertical: isActive ? 4.w : 3.5.w,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isActive
                                      ? const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF0F766E), // Mingda Deep Teal
                                            Color(0xFF14B8A6), // Mingda Accent Teal
                                          ],
                                        )
                                      : null,
                                  color: isActive ? null : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isActive
                                        ? Colors.white.withValues(alpha: 0.35)
                                        : const Color(0xFFE2E8F0),
                                    width: 0.8.w,
                                  ),
                                  boxShadow: isActive
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF0D9488).withValues(alpha: 0.30),
                                            offset: const Offset(0, 2),
                                            blurRadius: 6,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 5.w,
                                      height: 5.w,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? const Color(0xFF5EEAD4)
                                            : const Color(0xFF64748B),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      item.displayStatus.toUpperCase(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        color: isActive
                                            ? Colors.white
                                            : const Color(0xFF64748B),
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10.w),

                          // ─── BODY: Description (Kronologi Pelanggaran) ───
                          Text(
                            item.description,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF475569),
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: 10.w),

                          // Divider subtle
                          Divider(
                            color: const Color(0xFFF1F5F9),
                            height: 1.w,
                            thickness: 1.w,
                          ),

                          SizedBox(height: 8.w),

                          // ─── FOOTER: Tanggal Berlaku + Tombol Unduh PDF ───
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Tanggal Terbit - Berlaku s/d
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 13.w,
                                      color: const Color(0xFF64748B),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      child: Text(
                                        '${item.issuedDate} - ${item.validUntil}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF64748B),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8.w),

                              // Tombol Unduh PDF Resmi (Soft-Mint Style)
                              GestureDetector(
                                onTap: onDownload,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0FDFA),
                                    borderRadius: BorderRadius.circular(6.w),
                                    border: Border.all(
                                      color: const Color(0xFFCCFBF1),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.file_download_outlined,
                                        size: 13.w,
                                        color: const Color(0xFF0D9488),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Unduh PDF',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10.5.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF0D9488),
                                        ),
                                      ),
                                    ],
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
            ],
          ),
        ),
      ),
    );
  }
}
