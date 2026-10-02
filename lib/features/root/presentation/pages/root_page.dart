import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/profile_page.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/work_leave_page.dart';
import 'package:mingda_app/features/warning_letter/presentation/pages/warning_letter_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  final List<String> _iconsActive = const [
    'assets/icon/home-2.svg',
    'assets/icon/note-add.svg',
    'assets/icon/message-remove.svg',
    'assets/icon/empty-wallet.svg',
    'assets/icon/profile.svg',
  ];

  final List<String> _iconsNotActive = const [
    'assets/icon/home-2-not-active.svg',
    'assets/icon/note-add.svg',
    'assets/icon/message-remove.svg',
    'assets/icon/empty-wallet.svg',
    'assets/icon/profile-not-active.svg',
  ];

  final List<String> _titles = const [
    'Home',
    'Cuti',
    'Peringatan',
    'Wallet',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardPage(),
      const WorkLeavePage(),
      const WarningLetterPage(),
      const Center(child: Text('Wallet')),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (_) => sl<DashboardBloc>()..add(DashboardStarted()),
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is SignoutDashboardState) {
            Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
              '/login',
              (route) => false,
            );
          }
        },
        child: PopScope(
          canPop: _currentIndex == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            if (_currentIndex != 0) {
              setState(() {
                _currentIndex = 0;
              });
            }
          },
          child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: List.generate(_screens.length, (index) {
                final isSelected = _currentIndex == index;
                return AnimatedOpacity(
                  opacity: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeInOutCubic,
                  child: IgnorePointer(
                    ignoring: !isSelected,
                    child: _screens[index],
                  ),
                );
              }),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFF1F5F9),
                    width: 1.w,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 58.w,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_titles.length, (index) {
                        final isActive = _currentIndex == index;
                        return GestureDetector(
                          onTap: () {
                            if (_currentIndex != index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            }
                          },
                          behavior: HitTestBehavior.opaque,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeInOutCubic,
                            height: 40.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: isActive ? 14.w : 8.w,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.deepTeal50
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  isActive
                                      ? _iconsActive[index]
                                      : _iconsNotActive[index],
                                  width: 22.w,
                                  height: 22.w,
                                  colorFilter: ColorFilter.mode(
                                    isActive
                                        ? AppColors.deepTeal
                                        : const Color(0xFF484C52),
                                    BlendMode.srcIn,
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 260),
                                  curve: Curves.easeInOutCubic,
                                  child: isActive
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 6.w),
                                            Text(
                                              _titles[index],
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12.5.sp,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.deepTeal,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
