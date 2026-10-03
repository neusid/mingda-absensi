import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/app/config/app_config.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:mingda_app/features/auth/presentation/blocs/auth_state.dart';
import 'package:mingda_app/features/auth/presentation/widgets/InputAuth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextC = TextEditingController();
  TextEditingController passwordTextC = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    if (AppConfig.isOfflineMode) {
      emailTextC.text = 'admin@mingda.co.id';
      passwordTextC.text = 'password123';
      isChecked = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailTextC.dispose();
    passwordTextC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          if (context.mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/root',
              (route) => false,
            );
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.red,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.w),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.white,
                    size: 20.w,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      state.message,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is AuthRememberDataLoaded) {
          emailTextC.text = state.email;
          setState(() {});
        }
      },
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: const Color(0xFF042F2E),
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // ================= ABSTRACT TEAL GRADIENT BACKGROUND =================
              const Positioned.fill(
                child: _AbstractTealBackground(),
              ),

              // ================= SCROLLABLE CONTENT =================
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        // Top Header with brand pill and abstract ambience
                        _buildTopHeader(),

                        // Bottom White Card
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.zero,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(32.r),
                                topRight: Radius.circular(32.r),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  width: 1.5.w,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0F172A)
                                      .withValues(alpha: 0.16),
                                  blurRadius: 30,
                                  offset: const Offset(0, -8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 12.w),
                                // Handle bar
                                Container(
                                  width: 38.w,
                                  height: 4.w,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCBD5E1),
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                ),
                                SizedBox(height: 28.w),
                                SizedBox(
                                  width: 150.w,
                                  height: 56.w,
                                  child: Image.asset(
                                    "assets/img/mingda_logo.png",
                                  ),
                                ),
                                SizedBox(height: 40.w),
                                SizedBox(
                                  width: 322.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        context.tr.loginWelcomeBack,
                                        style: AppTextStyles.interExtraBold18,
                                      ),
                                      Text(
                                        context.tr.loginSubtitle,
                                        style: AppTextStyles
                                            .inter13RegularSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.w),
                                Column(
                                  spacing: 10.h,
                                  children: [
                                    InputAuth(
                                      label: context.tr.emailLabel,
                                      hintText: context.tr.emailHint,
                                      isPassword: false,
                                      controller: emailTextC,
                                      enabled: !isLoading,
                                    ),
                                    InputAuth(
                                      label: context.tr.passwordLabel,
                                      hintText: context.tr.passwordHint,
                                      isPassword: true,
                                      controller: passwordTextC,
                                      enabled: !isLoading,
                                    ),
                                    SizedBox(
                                      width: 322.w,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isChecked,
                                            visualDensity:
                                                VisualDensity.compact,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onChanged: isLoading
                                                ? null
                                                : (bool? value) {
                                                    setState(() {
                                                      isChecked =
                                                          value ?? false;
                                                    });
                                                  },
                                            activeColor:
                                                AppColors.filterTealAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4.r),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: Text(
                                              context.tr.rememberMe,
                                              style: AppTextStyles
                                                  .inter128RegularPrimary,
                                            ),
                                          ),
                                          GestureDetector(
                                            key: const Key('forgot_password_button'),
                                            onTap: isLoading
                                                ? null
                                                : () {
                                                    Navigator.pushNamed(
                                                      context,
                                                      '/forgot-password',
                                                    );
                                                  },
                                            child: Text(
                                              context.tr.forgotPassword,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12.sp,
                                                color: isLoading
                                                    ? AppColors.textTertiary
                                                    : AppColors.filterTealAccent,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30.w),
                                Column(
                                  spacing: 12.w,
                                  children: [
                                    // Gradient Sign In Button
                                    Container(
                                      width: 322.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.filterGradientStart,
                                            AppColors.filterGradientEnd,
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF0D9488)
                                                .withValues(alpha: 0.32),
                                            blurRadius: 14,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          onTap: isLoading
                                              ? null
                                              : () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  authBloc.add(
                                                    LoginSubmitted(
                                                      authSessionEntity:
                                                          AuthSessionEntity(
                                                        email:
                                                            emailTextC.text,
                                                        password: passwordTextC
                                                            .text,
                                                        isChecked: isChecked,
                                                      ),
                                                    ),
                                                  );
                                                },
                                          child: Center(
                                            child: isLoading
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width: 18.w,
                                                        height: 18.w,
                                                        child:
                                                            const CircularProgressIndicator(
                                                          strokeWidth: 2.2,
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            AppColors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                        context.tr.loggingIn,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              AppColors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    context.tr.loginButton,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: AppColors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14.sp,
                                                      letterSpacing: 0.3,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Sign In With Google Button
                                    Container(
                                      width: 322.w,
                                      height: 48.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        color: AppColors.white,
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                          width: 1.w,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF0F172A)
                                                .withValues(alpha: 0.04),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12.r),
                                          onTap: isLoading ? null : () {},
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 22.w,
                                                height: 22.w,
                                                child: Image.asset(
                                                  "assets/img/google_logo.png",
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "Sign In With Google",
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: isLoading
                                                      ? AppColors.textTertiary
                                                      : AppColors.textPrimary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.5.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.w),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopHeader() {
    return SizedBox(
      height: 147.w,
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.28),
                      width: 1.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        color: const Color(0xFF5EEAD4),
                        size: 15.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'MINGDA ATTENDANCE SYSTEM',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
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

/// Abstract Teal Gradient Background with glowing orbs, fluid curves, and geometric glass accents
class _AbstractTealBackground extends StatelessWidget {
  const _AbstractTealBackground();

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
            painter: _AbstractTealCurvesPainter(),
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
class _AbstractTealCurvesPainter extends CustomPainter {
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
