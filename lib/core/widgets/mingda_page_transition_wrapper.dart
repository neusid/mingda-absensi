import 'package:flutter/material.dart';

/// Wrapper animasi transisi halaman 2-tier Mingda.
///
/// Memberikan efek Pure Cross-Fade murni (tanpa geser/slide)
/// saat berpindah dari [MingdaPageLoading] ke konten atau skeleton.
class MingdaPageTransitionWrapper extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const MingdaPageTransitionWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 260),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeInOutCubic,
      switchOutCurve: Curves.easeInOutCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: child,
    );
  }
}
