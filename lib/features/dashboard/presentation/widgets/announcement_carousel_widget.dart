import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

class AnnouncementItem {
  final String category;
  final String title;
  final String description;
  final String date;
  final IconData icon;
  final List<Color> gradientColors;
  final Color badgeColor;

  const AnnouncementItem({
    required this.category,
    required this.title,
    required this.description,
    required this.date,
    required this.icon,
    required this.gradientColors,
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

  static const List<AnnouncementItem> _defaultAnnouncements = [
    AnnouncementItem(
      category: 'OPERASIONAL',
      title: 'Penyesuaian Jadwal Shift Kerja',
      description: 'Efektif per 15 Oktober 2026 untuk seluruh divisi pabrik.',
      date: '01 Okt 2026',
      icon: Icons.campaign_rounded,
      gradientColors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
      badgeColor: Color(0xFF0D9488),
    ),
    AnnouncementItem(
      category: 'KEBIJAKAN HR',
      title: 'Prosedur Pengajuan Cuti Tahunan',
      description: 'Pengajuan cuti wajib diajukan minimal H-3 melalui aplikasi.',
      date: '28 Sep 2026',
      icon: Icons.event_available_rounded,
      gradientColors: [Color(0xFF1E293B), Color(0xFF334155)],
      badgeColor: Color(0xFF475569),
    ),
    AnnouncementItem(
      category: 'KESEHATAN & K3',
      title: 'Medical Check-Up Tahunan 2026',
      description: 'Pelaksanaan MCU berkala di Klinik Pratama PT Mingda.',
      date: '25 Sep 2026',
      icon: Icons.health_and_safety_rounded,
      gradientColors: [Color(0xFF0284C7), Color(0xFF0369A1)],
      badgeColor: Color(0xFF0284C7),
    ),
  ];

  List<AnnouncementItem> get _announcements =>
      widget.items ?? _defaultAnnouncements;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_pageController.hasClients) return;
      final nextIndex = (_currentIndex + 1) % _announcements.length;
      _pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 500),
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
    if (_announcements.isEmpty) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Banner Card View
        SizedBox(
          width: 326.w,
          height: 125.w,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _announcements.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = _announcements[index];
              return _buildBannerCard(item);
            },
          ),
        ),
        SizedBox(height: 8.w),

        // 2. Dot Indicator (Matching Figma announcement_carousel.svg)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_announcements.length, (index) {
            final isActive = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
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
      height: 125.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.gradientColors,
        ),
        boxShadow: [AppShadows.shadow094],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.w),
          canRequestFocus: false,
          onTap: () {
            // Ripple feedback only as agreed
          },
          child: Stack(
            children: [
              // Decorative background subtle shape
              Positioned(
                right: -15.w,
                bottom: -20.w,
                child: Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                right: 18.w,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    child: Center(
                      child: Icon(
                        item.icon,
                        size: 26.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // Content text & badge
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
                            horizontal: 6.w,
                            vertical: 2.w,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(4.w),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 8.5.w,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          item.date,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9.w,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),

                    // Title
                    SizedBox(
                      width: 220.w,
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.5.w,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.25,
                        ),
                      ),
                    ),

                    // Description
                    SizedBox(
                      width: 230.w,
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
            ],
          ),
        ),
      ),
    );
  }
}
