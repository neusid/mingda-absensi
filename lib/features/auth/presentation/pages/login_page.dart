import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/app/config/app_config.dart';
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
          backgroundColor: AppColors.deepTeal,
          resizeToAvoidBottomInset: true,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(height: 147.w),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.w),
                            topRight: Radius.circular(30.w),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60.w),
                            SizedBox(
                              width: 150.w,
                              height: 56.w,
                              child: Image.asset(
                                "assets/img/mingda_logo.png",
                              ),
                            ),
                            SizedBox(height: 60.w),
                            SizedBox(
                              width: 322.w,
                              height: 74.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5.w,
                                children: [
                                  Text(
                                    "Welcome Back, 👋",
                                    style: AppTextStyles.interExtraBold18,
                                  ),
                                  Text(
                                    "Please enter your login details to access your account.",
                                    style: AppTextStyles.inter13RegularSecondary,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.w),
                            Column(
                              spacing: 10.h,
                              children: [
                                InputAuth(
                                  label: "E-Mail",
                                  hintText: "Enter your email",
                                  isPassword: false,
                                  controller: emailTextC,
                                  enabled: !isLoading,
                                ),
                                InputAuth(
                                  label: "Password",
                                  hintText: "Enter your password",
                                  isPassword: true,
                                  controller: passwordTextC,
                                  enabled: !isLoading,
                                ),
                                SizedBox(
                                  width: 345.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                            value: isChecked,
                                            onChanged: isLoading
                                                ? null
                                                : (bool? value) {
                                                    setState(() {
                                                      isChecked = value ?? false;
                                                    });
                                                  },
                                            activeColor: AppColors.deepTeal,
                                          ),
                                          Text(
                                            "Remember me",
                                            style: AppTextStyles.inter128RegularPrimary,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 98.w),
                                      Text(
                                        "Forgot Password",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12.sp,
                                          color: isLoading
                                              ? AppColors.textTertiary
                                              : Colors.blue,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.w),
                            Column(
                              spacing: 10.w,
                              children: [
                                SizedBox(
                                  width: 322.w,
                                  height: 45.w,
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            FocusScope.of(context).unfocus();
                                            authBloc.add(
                                              LoginSubmitted(
                                                authSessionEntity:
                                                    AuthSessionEntity(
                                                  email: emailTextC.text,
                                                  password: passwordTextC.text,
                                                  isChecked: isChecked,
                                                ),
                                              ),
                                            );
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.deepTeal,
                                      disabledBackgroundColor:
                                          AppColors.deepTeal.withValues(alpha: 0.65),
                                      splashFactory: InkRipple.splashFactory,
                                      overlayColor: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                    ),
                                    child: isLoading
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 18.w,
                                                height: 18.w,
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 2.2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(AppColors.white),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "Signing In...",
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  color: AppColors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.sp,
                                            ),
                                          ),
                                  ),
                                ),
                                SizedBox(
                                  width: 322.w,
                                  height: 45.w,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.white,
                                      disabledBackgroundColor:
                                          AppColors.white.withValues(alpha: 0.6),
                                      splashFactory: InkRipple.splashFactory,
                                      overlayColor: Colors.black54,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.w),
                                        side: BorderSide(
                                          color: AppColors.inputColorBorder
                                              .withAlpha(25),
                                          width: 1.w,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      spacing: 10.w,
                                      children: [
                                        SizedBox(
                                          width: 24.w,
                                          height: 24.w,
                                          child: Image.asset(
                                            "assets/img/google_logo.png",
                                          ),
                                        ),
                                        Text(
                                          "Sign In With Google",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: isLoading
                                                ? AppColors.textTertiary
                                                : AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
