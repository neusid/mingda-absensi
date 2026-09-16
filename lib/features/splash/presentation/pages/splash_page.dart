import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/widgets/skeleton.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    context.read<SplashBloc>().add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SuccessSplashState) {
          Navigator.pushReplacementNamed(context, '/root');
        } else if (state is FailureSplashState) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: SkeletonLoading(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SkeletonBox(width: 200.w, height: 150.w, radius: 10.w),
                SizedBox(height: 24.w),
                SkeletonBox(width: 242.w, height: 16.w, radius: 4.w),
                SizedBox(height: 8.w),
                SkeletonBox(width: 100.w, height: 16.w, radius: 4.w),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
