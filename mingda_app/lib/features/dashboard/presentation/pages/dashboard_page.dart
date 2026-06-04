import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dasboardBloc = context.read<DashboardBloc>();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is DashboardSignout) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => dasboardBloc.add(DashboardSignout()),
                child: Text("LogOut"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
