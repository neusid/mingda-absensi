import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';
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
    // TODO: implement initState
    super.initState();
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthRememberDataLoaded) {
          emailTextC.text = state.email;
          setState(() {});
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.deepTeal,
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              CustomScrollView(
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
                                Container(
                                  width: 322.w,
                                  height: 74.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        "Welcome Back, 👋",
                                        style: AppTextStyles.interExtraBold18,
                                      ),
                                      Text(
                                        "Please enter your login details to access your account.",
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
                                      label: "E-Mail",
                                      hintText: "Enter your email",
                                      isPassword: false,
                                      controller: emailTextC,
                                    ),
                                    InputAuth(
                                      label: "Password",
                                      hintText: "Enter your password",
                                      isPassword: true,
                                      controller: passwordTextC,
                                    ),
                                    SizedBox(
                                      width: 345.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isChecked,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    isChecked = value ?? false;
                                                  });
                                                },
                                                activeColor: AppColors.deepTeal,
                                              ),
                                              Text(
                                                "Remember me",
                                                style: AppTextStyles
                                                    .inter128RegularPrimary,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 98.w),
                                          Text(
                                            "Forgot Password",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12.sp,
                                              color: Colors.blue,
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
                                        // onPressed: _onLoginPressed,
                                        onPressed: () {
                                          authBloc.add(
                                            LoginSubmitted(
                                              authSessionEntity:
                                                  AuthSessionEntity(
                                                    email: emailTextC.text,
                                                    password:
                                                        passwordTextC.text,
                                                    isChecked: isChecked,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Sign In",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.deepTeal,
                                          splashFactory:
                                              InkRipple.splashFactory,
                                          overlayColor: AppColors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10.w,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 322.w,
                                      height: 45.w,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.white,
                                          splashFactory:
                                              InkRipple.splashFactory,
                                          overlayColor: Colors.black54,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10.w,
                                                ),
                                            side: BorderSide(
                                              color: AppColors.inputColorBorder
                                                  .withAlpha(25),
                                              width: 1.w,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              state is AuthLoading
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black26,
                        child: Center(
                          child: SkeletonLoading(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SkeletonBox(width: 200.w, height: 20.w),
                                SizedBox(height: 10.w),
                                SkeletonBox(width: 160.w, height: 20.w),
                                SizedBox(height: 10.w),
                                SkeletonBox(width: 180.w, height: 40.w, radius: 10.w),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        );
        if (state is AuthLoading) {}
      },
    );
  }
}
