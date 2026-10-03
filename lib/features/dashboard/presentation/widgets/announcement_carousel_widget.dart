import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/localization/app_language.dart';
import 'package:mingda_app/core/localization/bloc/language_bloc.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

class AnnouncementItem {
  final String category;
  final String title;
  final String description;
  final String date;
  final String imagePath;
  final Color badgeColor;

  const AnnouncementItem({
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
    required this.badgeColor,
  });
}

class AnnouncementCarouselWidget extends StatefulWidget {
  final List<AnnouncementItem>? items;

  const AnnouncementCarouselWidget({
    super.key,
    this.items,
  });

  @override
  State<AnnouncementCarouselWidget> createState() =>
      _AnnouncementCarouselWidgetState();
}

class _AnnouncementCarouselWidgetState
    extends State<AnnouncementCarouselWidget> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  static const List<AnnouncementItem> _defaultAnnouncementsId = [
    AnnouncementItem(
      category: 'PRESENSI & BIOMETRIK',
      title: 'Pembaruan Mesin Fingerprint & SOP',
      description: 'Pastikan jari bersih saat tapping mesin presensi biometrik.',
      date: '01 Okt 2026',
      imagePath: 'assets/img/announcement_biometric.jpg',
      badgeColor: Color(0xFF0D9488),
    ),
    AnnouncementItem(
      category: 'KESELAMATAN & K3',
      title: 'Audit K3 & Standar APD Pabrik',
      description: 'Wajib mengenakan helm & rompi safety di area produksi.',
      date: '28 Sep 2026',
      imagePath: 'assets/img/announcement_safety.jpg',
      badgeColor: Color(0xFFD97706),
    ),
    AnnouncementItem(
      category: 'CUTI & LIBUR',
      title: 'Pengumuman Cuti Bersama 2026',
      description: 'Jadwal operasional libur nasional & cuti bersama karyawan.',
      date: '25 Sep 2026',
      imagePath: 'assets/img/announcement_holiday.jpg',
      badgeColor: Color(0xFF4F46E5),
    ),
  ];

  static const List<AnnouncementItem> _defaultAnnouncementsEn = [
    AnnouncementItem(
      category: 'ATTENDANCE & BIOMETRIC',
      title: 'Fingerprint Machine & SOP Update',
      description: 'Ensure clean fingers when tapping the biometric machine.',
      date: '01 Oct 2026',
      imagePath: 'assets/img/announcement_biometric.jpg',
      badgeColor: Color(0xFF0D9488),
    ),
    AnnouncementItem(
      category: 'SAFETY & HSE',
      title: 'HSE Audit & Plant PPE Standards',
      description: 'Safety helmet & vest are strictly required in the production area.',
      date: '28 Sep 2026',
      imagePath: 'assets/img/announcement_safety.jpg',
      badgeColor: Color(0xFFD97706),
    ),
    AnnouncementItem(
      category: 'LEAVE & HOLIDAYS',
      title: 'Company Joint Holiday Notice 2026',
      description: 'Operational schedule for national holidays and collective leave.',
      date: '25 Sep 2026',
      imagePath: 'assets/img/announcement_holiday.jpg',
      badgeColor: Color(0xFF4F46E5),
    ),
  ];

  static const List<AnnouncementItem> _defaultAnnouncementsZh = [
    AnnouncementItem(
      category: '考勤与生物识别',
      title: '指纹打卡机与操作规范更新',
      description: '使用生物识别打卡机时请确保手指干净。',
      date: '2026年10月01日',
      imagePath: 'assets/img/announcement_biometric.jpg',
      badgeColor: Color(0xFF0D9488),
    ),
    AnnouncementItem(
      category: '安全与健康 (HSE)',
      title: '安全生产审查及个人防护标准',
      description: '生产车间区域内必须佩戴安全帽和反光背心。',
      date: '2026年09月28日',
      imagePath: 'assets/img/announcement_safety.jpg',
      badgeColor: Color(0xFFD97706),
    ),
    AnnouncementItem(
      category: '休假与节日',
      title: '2026年度公共假期安排通知',
      description: '法定节假日及公司统筹休假运营安排。',
      date: '2026年09月25日',
      imagePath: 'assets/img/announcement_holiday.jpg',
      badgeColor: Color(0xFF4F46E5),
    ),
  ];

  late final int _initialPage;

  List<AnnouncementItem> _getAnnouncements(AppLanguage lang) {
    if (widget.items != null) return widget.items!;
    switch (lang) {
      case AppLanguage.en:
        return _defaultAnnouncementsEn;
      case AppLanguage.zh:
        return _defaultAnnouncementsZh;
      case AppLanguage.id:
        return _defaultAnnouncementsId;
    }
  }

  @override
  void initState() {
    super.initState();
    final count = widget.items?.length ?? 3;
    _initialPage = count * 1000;
    _pageController = PageController(initialPage: _initialPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageBloc?>()?.state.language ?? AppLanguage.id;
    final announcements = _getAnnouncements(lang);
    if (announcements.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Full Image Banner View (Infinite Smooth Carousel)
        SizedBox(
          width: 326.w,
          height: 135.w,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _stopAutoScroll();
              } else if (notification is ScrollEndNotification) {
                _startAutoScroll();
              }
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index % announcements.length;
                });
              },
              itemBuilder: (context, index) {
                final item = announcements[index % announcements.length];
                return _buildBannerCard(item);
              },
            ),
          ),
        ),
        SizedBox(height: 8.w),

        // 2. Dot Indicator (Matching Figma announcement_carousel.svg)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(announcements.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              margin: EdgeInsets.symmetric(horizontal: 3.w),
              width: isActive ? 16.w : 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.filterTealAccent
                    : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3.w),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBannerCard(AnnouncementItem item) {
    return Container(
      width: 326.w,
      height: 135.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        boxShadow: [AppShadows.shadow094],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.w),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. Background Photographic Image from Assets
            Image.asset(
              item.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF1E293B),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.white54,
                    size: 32,
                  ),
                ),
              ),
            ),

            // 2. Scrim Gradient Overlay for Text Readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.0, 0.55, 1.0],
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.50),
                    Colors.black.withValues(alpha: 0.15),
                  ],
                ),
              ),
            ),

            // 3. Subtle bottom vignette
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.5, 1.0],
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.40),
                  ],
                ),
              ),
            ),

            // 4. Content Text, Tag & Date
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
                vertical: 12.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Row 1: Category Tag + Date
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.5.w,
                        ),
                        decoration: BoxDecoration(
                          color: item.badgeColor.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 8.5.w,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.date,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 9.w,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.80),
                        ),
                      ),
                    ],
                  ),

                  // Title (Teks di Tengah - Dibatasi hingga tengah card agar ganti baris)
                  SizedBox(
                    width: 155.w,
                    child: Text(
                      item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.w,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.25,
                      ),
                    ),
                  ),

                  // Description (Teks di Bawah)
                  SizedBox(
                    width: 240.w,
                    child: Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.w,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.90),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Interactive Ripple Feedback
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.w),
                canRequestFocus: false,
                onTap: () {
                  // Touch ripple feedback
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
