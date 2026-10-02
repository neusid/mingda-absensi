import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';

/// Remake Profile Header Card
///
/// Fitur & Desain:
/// - Avatar Monogram Inisial (contoh: "LV", "MA", dll) berlatar Signature Mingda
///   Teal Gradient (#0F766E -> #14B8A6), tanpa efek glow, bersih dan tajam.
/// - Ukuran avatar (62.w) sejajar simetris dari batas atas teks "Selamat Datang"
///   hingga batas bawah box email.
/// - Shadow kanonikal Mingda [AppShadows.shadow094] dengan border putih bersih.
/// - Teks nama karyawan dan box email menggunakan warna Teal (#17768A).
class ProfileHeaderCard extends StatelessWidget {
  final ProfileEntity profile;
  final VoidCallback? onNotificationTap;
  final bool isOnline;
  final bool hasUnreadNotification;

  static const double _contentHeight = 62.0;

  const ProfileHeaderCard({
    super.key,
    required this.profile,
    this.onNotificationTap,
    this.isOnline = true,
    this.hasUnreadNotification = true,
  });

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'MD';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (trimmed.length >= 2) {
      return trimmed.substring(0, 2).toUpperCase();
    }
    return trimmed.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white, width: 1.5.w),
        boxShadow: const [AppShadows.shadow094],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(),
          SizedBox(width: 14.w),
          Expanded(child: _buildUserInfo()),
          SizedBox(width: 10.w),
          _buildNotificationButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    final initials = _getInitials(profile.name);
    final size = _contentHeight.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Squircle Monogram Avatar with Signature Mingda Teal Gradient (Clean, No Glow)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.white,
                width: 1.5.w,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.filterGradientStart, // #0F766E
                  AppColors.filterGradientEnd,   // #14B8A6
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
          ),

          // Active Status Online Dot (Sudut Kanan Bawah)
          if (isOnline)
            Positioned(
              right: -1.w,
              bottom: -1.w,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF00AA13),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.w,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return SizedBox(
      height: _contentHeight.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Batas Atas: Micro Greeting "Selamat Datang 👋"
          Text(
            'Selamat Datang 👋',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF64748B),
              letterSpacing: 0.1,
              height: 1.1,
            ),
          ),

          // 2. Tengah: Nama Karyawan (Warna Teal #17768A)
          Text(
            profile.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.5.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.deepTeal,
              letterSpacing: -0.2,
              height: 1.2,
            ),
          ),

          // 3. Batas Bawah: Box Email Capsule Badge (Warna Teal #17768A)
          Container(
            height: 23.w,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDFA),
              borderRadius: BorderRadius.circular(11.5.r),
              border: Border.all(
                color: const Color(0xFF99F6E4),
                width: 0.9.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mail_outline_rounded,
                  size: 12.w,
                  color: AppColors.deepTeal,
                ),
                SizedBox(width: 5.w),
                Flexible(
                  child: Text(
                    profile.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepTeal,
                      letterSpacing: -0.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          width: 1.w,
        ),
        boxShadow: const [AppShadows.shadow094],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(13.r),
          onTap: onNotificationTap ?? () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 19.w,
                color: const Color(0xFF0F172A),
              ),
              if (hasUnreadNotification)
                Positioned(
                  top: 8.w,
                  right: 8.w,
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFED2736),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5.w,
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
