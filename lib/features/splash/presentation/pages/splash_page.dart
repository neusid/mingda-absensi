import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/widgets/mingda_page_loading.dart';
import 'package:mingda_app/features/splash/presentation/blocs/splash_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashBloc>().add(AppStarted());
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
      child: const Scaffold(
        backgroundColor: AppColors.bg,
        body: MingdaPageLoading(),
      ),
    );
  }
}
