import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/di/injection_container.dart';
import 'package:mingda_app/core/localization/app_translations.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:mingda_app/features/auth/presentation/widgets/InputAuth.dart';
import 'package:mingda_app/features/auth/presentation/widgets/abstract_teal_background.dart';

class ForgotPasswordPage extends StatefulWidget {
  final ForgotPasswordUseCase? forgotPasswordUseCase;

  const ForgotPasswordPage({
    super.key,
    this.forgotPasswordUseCase,
  });

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _successMessage;
  int _resendCountdown = 0;
  Timer? _timer;

  late final ForgotPasswordUseCase _useCase;

  @override
  void initState() {
    super.initState();
    _useCase = widget.forgotPasswordUseCase ?? sl<ForgotPasswordUseCase>();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() => _resendCountdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 1) {
        timer.cancel();
        if (mounted) setState(() => _resendCountdown = 0);
      } else {
        if (mounted) setState(() => _resendCountdown--);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final result = await _useCase(email);

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.red,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
            content: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20.w,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    failure.message.toString(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      (message) {
        setState(() {
          _isSuccess = true;
          _successMessage = message;
        });
        _startResendTimer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF042F2E),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ================= ABSTRACT TEAL GRADIENT BACKGROUND =================
          const Positioned.fill(
            child: AbstractTealBackground(),
          ),

          // ================= SCROLLABLE CONTENT MATCHING LOGIN PAGE =================
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    // Top Header with brand pill and back button
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
                              color: const Color(0xFF0F172A).withValues(alpha: 0.16),
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
                            // Mingda Logo
                            SizedBox(
                              width: 150.w,
                              height: 56.w,
                              child: Image.asset(
                                "assets/img/mingda_logo.png",
                              ),
                            ),
                            SizedBox(height: 36.w),

                            // Form or Success Animated View
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 280),
                              crossFadeState: _isSuccess
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild: _buildFormView(),
                              secondChild: _buildSuccessView(),
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
  }

  /// Top Header with Brand Pill and Back Navigation
  Widget _buildTopHeader() {
    return SizedBox(
      height: 147.w,
      width: double.infinity,
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered Brand Pill
            Container(
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
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    size: 15.w,
                    color: const Color(0xFF5EEAD4),
                  ),
                  SizedBox(width: 7.w),
                  Text(
                    "MINGDA ATTENDANCE SYSTEM",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.95),
                      letterSpacing: 0.9,
                    ),
                  ),
                ],
              ),
            ),

            // Frosted Glass Back Button on the left
            Positioned(
              left: 20.w,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const Key('forgot_password_back_button'),
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.28),
                        width: 1.w,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 15.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Initial Form View (Email Input & Reset Action)
  Widget _buildFormView() {
    return SizedBox(
      width: 322.w,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with Lock Reset Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5.w,
                    children: [
                      Text(
                        context.tr.forgotPasswordQuestion,
                        style: AppTextStyles.interExtraBold18,
                      ),
                      Text(
                        context.tr.forgotPasswordInstruction,
                        style: AppTextStyles.inter13RegularSecondary,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDFA),
                    borderRadius: BorderRadius.circular(13.r),
                    border: Border.all(
                      color: const Color(0xFFCCFBF1),
                      width: 1.2.w,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 22.w,
                    color: AppColors.filterTealAccent,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.w),

            // Email Input using standard InputAuth matching login_page
            InputAuth(
              fieldKey: const Key('forgot_password_email_input'),
              label: context.tr.forgotPasswordEmailLabel,
              hintText: context.tr.emailHint,
              isPassword: false,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                size: 19.w,
                color: const Color(0xFF94A3B8),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Alamat email wajib diisi';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            SizedBox(height: 14.w),

            // Security Advisory Notice
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDFA),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFF99F6E4),
                  width: 1.w,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 17.w,
                    color: AppColors.filterTealAccent,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tautan verifikasi berlaku selama 60 menit. Hubungi HRD jika mengalami kendala.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5.sp,
                        color: const Color(0xFF0F766E),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.w),

            // Action Buttons matching login_page button rhythm
            Column(
              spacing: 12.w,
              children: [
                // Gradient Submit Button (width: 322.w, height: 48.w, radius 12.r)
                Container(
                  width: 322.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
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
                        color: const Color(0xFF0D9488).withValues(alpha: 0.32),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: const Key('submit_forgot_password_button'),
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: _isLoading ? null : _handleSubmit,
                      child: Center(
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 18.w,
                                    height: 18.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "Mengirim...",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 8.w),
                                      Text(
                                        context.tr.sendRecoveryLink,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.5.sp,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),

                // Secondary Button: Back to Login (matches LoginPage outlined secondary action)
                Container(
                  width: 322.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      key: const Key('back_to_login_button'),
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () => Navigator.pop(context),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 18.w,
                                  color: AppColors.textPrimary,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  context.tr.backToLogin,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Success Confirmation View
  Widget _buildSuccessView() {
    return SizedBox(
      width: 322.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.w),

          // Gojek-style solid success badge
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFBBF7D0),
                width: 1.5.w,
              ),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: const BoxDecoration(
                color: Color(0xFF00AA13), // Gojek Green Solid
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.check_rounded,
                size: 24.w,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(height: 16.w),

          Text(
            context.tr.emailSentTitle,
            style: AppTextStyles.interExtraBold18,
          ),
          SizedBox(height: 6.w),
          Text(
            context.tr.emailSentSubtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.inter13RegularSecondary,
          ),

          SizedBox(height: 12.w),

          // Target Email Chip
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1.w,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.mark_email_read_rounded,
                  size: 16.w,
                  color: AppColors.filterTealAccent,
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    _emailController.text.trim(),
                    key: const Key('success_target_email_text'),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.w),

          // Security Expire Info
          Text(
            _successMessage ??
                'Tautan berlaku 60 menit. Periksa folder Inbox dan Spam Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5.sp,
              color: const Color(0xFF0F766E),
              height: 1.35,
            ),
          ),

          SizedBox(height: 24.w),

          // Primary Action: Kembali ke Login (width: 322.w, height: 48.w)
          Container(
            width: 322.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
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
                  color: const Color(0xFF0D9488).withValues(alpha: 0.32),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('success_back_to_login_button'),
                borderRadius: BorderRadius.circular(12.r),
                onTap: () => Navigator.pop(context),
                child: Center(
                  child: Text(
                    context.tr.backToLogin,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 12.w),

          // Resend Timer Option
          TextButton(
            key: const Key('resend_email_button'),
            onPressed: (_resendCountdown > 0 || _isLoading)
                ? null
                : () => _handleSubmit(),
            child: Text(
              _resendCountdown > 0
                  ? '${context.tr.resendIn} ${_resendCountdown}s'
                  : context.tr.resendEmail,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: _resendCountdown > 0
                    ? const Color(0xFF94A3B8)
                    : AppColors.filterTealAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
