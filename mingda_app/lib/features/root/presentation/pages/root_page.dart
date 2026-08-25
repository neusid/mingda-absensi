import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mingda_app/features/dashboard/presentation/pages/profile_page.dart';
import 'package:mingda_app/features/work_leave/presentation/pages/work_leave_page.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/di/injection_container.dart';

class RootPage extends StatefulWidget {
  RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  late final List<Widget> _screens;
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  @override
  void initState() {
    super.initState();

    _controller.addListener(() => setState(() {}));

    _screens = [
      DashboardPage(),
      const WorkLeavePage(),
      const Center(child: Text('Surat Peringatan')),
      const Center(child: Text('Wallet')),
      const ProfilePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    final iconsActive = [
      'assets/icon/home-2.svg',
      'assets/icon/note-add.svg',
      'assets/icon/message-remove.svg',
      'assets/icon/empty-wallet.svg',
      'assets/icon/profile.svg',
    ];

    final iconsNotActive = [
      'assets/icon/home-2-not-active.svg',
      'assets/icon/note-add.svg',
      'assets/icon/message-remove.svg',
      'assets/icon/empty-wallet.svg',
      'assets/icon/profile-not-active.svg',
    ];

    final titles = ['Home', 'Cuti', 'Peringatan', 'Wallet', 'Profile'];

    return List.generate(titles.length, (index) {
      final isActive = _controller.index == index;
      return PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          isActive ? iconsActive[index] : iconsNotActive[index],
        ),
        title: titles[index],
        textStyle: AppTextStyles.inter12MediumDeepTeal,
        activeColorPrimary: AppColors.deepTeal,
        inactiveColorPrimary: Colors.grey,
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(
      create: (_) => sl<DashboardBloc>()..add(DashboardStarted()),
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
