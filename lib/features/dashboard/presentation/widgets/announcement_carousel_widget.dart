import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';

class AnnouncementItem {
  final String category;
  final String date;
  final String imagePath;
  final Color badgeColor;

  const AnnouncementItem({
    required this.category,
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

  static const List<AnnouncementItem> _defaultAnnouncements = [
    AnnouncementItem(
      category: 'PRESENSI & BIOMETRIK',
      date: '01 Okt 2026',
      imagePath: 'assets/img/announcement_biometric.jpg',
      badgeColor: Color(0xFF0D9488),
    ),
    AnnouncementItem(
      category: 'KESELAMATAN & K3',
      date: '28 Sep 2026',
      imagePath: 'assets/img/announcement_safety.jpg',
      badgeColor: Color(0xFFD97706),
    ),
    AnnouncementItem(
      category: 'CUTI & LIBUR',
      date: '25 Sep 2026',
      imagePath: 'assets/img/announcement_holiday.jpg',
      badgeColor: Color(0xFF4F46E5),
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
        // 1. Full Image Banner View
        SizedBox(
          width: 326.w,
          height: 135.w,
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

            // 2. Subtle top vignette for tag & date readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.40],
                  colors: [
                    Colors.black.withValues(alpha: 0.40),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // 3. Tag (Top-Left) & Date (Top-Right)
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.5.w,
                    ),
                    decoration: BoxDecoration(
                      color: item.badgeColor.withValues(alpha: 0.90),
                      borderRadius: BorderRadius.circular(5.w),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      item.category,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 8.5.w,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.5.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.50),
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    child: Text(
                      item.date,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 9.w,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Interactive Ripple Feedback
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
