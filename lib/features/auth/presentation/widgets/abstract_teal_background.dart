import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Abstract Teal Gradient Background with glowing orbs, fluid curves, and geometric glass accents
class AbstractTealBackground extends StatelessWidget {
  const AbstractTealBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Multi-stop Teal Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF042F2E), // Deep midnight teal
                Color(0xFF0F766E), // Corporate teal start
                Color(0xFF115E59), // Rich medium teal
                Color(0xFF0D9488), // Signature corporate teal
              ],
              stops: [0.0, 0.35, 0.70, 1.0],
            ),
          ),
        ),

        // Fluid Abstract Vector Curves Painter
        Positioned.fill(
          child: CustomPaint(
            painter: AbstractTealCurvesPainter(),
          ),
        ),

        // Glowing Radial Orb 1 (Top Right)
        Positioned(
          top: -60.w,
          right: -40.w,
          child: Container(
            width: 260.w,
            height: 260.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF2DD4BF).withValues(alpha: 0.35),
                  const Color(0xFF14B8A6).withValues(alpha: 0.12),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.55, 1.0],
              ),
            ),
          ),
        ),

        // Glowing Radial Orb 2 (Mid Left)
        Positioned(
          top: 60.w,
          left: -60.w,
          child: Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF14B8A6).withValues(alpha: 0.25),
                  const Color(0xFF0F766E).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.60, 1.0],
              ),
            ),
          ),
        ),

        // Abstract Concentric Rings (Top Left)
        Positioned(
          top: 15.w,
          left: -25.w,
          child: Container(
            width: 170.w,
            height: 170.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF5EEAD4).withValues(alpha: 0.16),
                width: 1.2.w,
              ),
            ),
          ),
        ),
        Positioned(
          top: 40.w,
          left: 0,
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF2DD4BF).withValues(alpha: 0.10),
                width: 1.w,
              ),
            ),
          ),
        ),

        // Abstract Rotated Frosted Squircle (Top Right / Center)
        Positioned(
          top: -20.w,
          right: 25.w,
          child: Transform.rotate(
            angle: -0.32,
            child: Container(
              width: 140.w,
              height: 140.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.r),
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                  width: 1.w,
                ),
              ),
            ),
          ),
        ),

        // Smaller Abstract Diamond Squircle (Floating Mid-Right)
        Positioned(
          top: 80.w,
          right: -10.w,
          child: Transform.rotate(
            angle: 0.42,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                color: const Color(0xFF2DD4BF).withValues(alpha: 0.06),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// CustomPainter that renders fluid abstract waves & glowing contours in teal
class AbstractTealCurvesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Upper sweeping abstract wave
    final path1 = Path();
    path1.moveTo(0, size.height * 0.18);
    path1.cubicTo(
      size.width * 0.35,
      size.height * 0.08,
      size.width * 0.65,
      size.height * 0.28,
      size.width,
      size.height * 0.15,
    );
    path1.lineTo(size.width, 0);
    path1.lineTo(0, 0);
    path1.close();

    final paint1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF2DD4BF).withValues(alpha: 0.20),
          const Color(0xFF14B8A6).withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.3));

    canvas.drawPath(path1, paint1);

    // Diagonal intersecting secondary wave
    final path2 = Path();
    path2.moveTo(0, size.height * 0.32);
    path2.cubicTo(
      size.width * 0.4,
      size.height * 0.22,
      size.width * 0.7,
      size.height * 0.38,
      size.width,
      size.height * 0.24,
    );
    path2.lineTo(size.width, 0);
    path2.lineTo(0, 0);
    path2.close();

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          const Color(0xFF14B8A6).withValues(alpha: 0.14),
          const Color(0xFF0F766E).withValues(alpha: 0.04),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4));

    canvas.drawPath(path2, paint2);

    // Glowing subtle contour stroke line
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          const Color(0xFF5EEAD4).withValues(alpha: 0.30),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePath = Path();
    linePath.moveTo(0, size.height * 0.25);
    linePath.cubicTo(
      size.width * 0.3,
      size.height * 0.15,
      size.width * 0.75,
      size.height * 0.30,
      size.width,
      size.height * 0.18,
    );
    canvas.drawPath(linePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
