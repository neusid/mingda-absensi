import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/pages/login_page.dart';
import 'package:mingda_app/features/root/presentation/pages/root_page.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';
import 'package:mingda_app/features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<SplashBloc>(),
            child: SplashPage(),
          ),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => sl<AuthBloc>()..add(AuthStarted()),
            child: LoginPage(),
          ),
        );
      case '/root':
        return MaterialPageRoute(builder: (context) => RootPage());
      // case '/dashboard':
      //   return MaterialPageRoute(
      //     builder: (context) => BlocProvider(
      //       create: (context) => sl<DashboardBloc>()..add(DashboardStarted()),
      //       child: DashboardPage(),
      //     ),
      //   );
      default:
        return MaterialPageRoute(builder: (context) => LoginPage());
    }
  }
}
