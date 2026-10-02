import 'package:flutter/material.dart';

/// Custom Page Route bergaya Pure Silk Cross-Fade.
///
/// Layar baru memudar masuk (fade in) dan layar sebelumnya memudar keluar (fade out)
/// secara simultan dan mulus tanpa gerakan geser (no sliding), memberikan impresi
/// perpindahan yang tenang, bersih, dan mewah.
class MingdaPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  MingdaPageRoute({
    required this.child,
    super.settings,
    super.transitionDuration = const Duration(milliseconds: 260),
    super.reverseTransitionDuration = const Duration(milliseconds: 240),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fadeIn = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            );

            final fadeOut = Tween<double>(
              begin: 1.0,
              end: 0.0,
            ).animate(CurvedAnimation(
              parent: secondaryAnimation,
              curve: Curves.easeInOutCubic,
              reverseCurve: Curves.easeInOutCubic,
            ));

            return FadeTransition(
              opacity: fadeOut,
              child: FadeTransition(
                opacity: fadeIn,
                child: child,
              ),
            );
          },
        );
}

/// Global PageTransitionsBuilder untuk Pure Silk Cross-Fade pada level ThemeData.
class MingdaFadePageTransitionsBuilder extends PageTransitionsBuilder {
  const MingdaFadePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeIn = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );

    final fadeOut = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: secondaryAnimation,
      curve: Curves.easeInOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    ));

    return FadeTransition(
      opacity: fadeOut,
      child: FadeTransition(
        opacity: fadeIn,
        child: child,
      ),
    );
  }
}
