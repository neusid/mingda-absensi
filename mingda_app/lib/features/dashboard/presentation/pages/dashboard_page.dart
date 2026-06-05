import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingda_app/core/theme/app_colors.dart';
import 'package:mingda_app/core/theme/app_shadows.dart';
import 'package:mingda_app/core/theme/app_text_styles.dart';
import 'package:mingda_app/core/utils/date_formatter.dart';
import 'package:mingda_app/features/dashboard/presentation/blocs/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dasboardBloc = context.read<DashboardBloc>();
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: BlocListener<DashboardBloc, DashboardState>(
        bloc: dasboardBloc,
        listener: (context, state) {
          // TODO: implement listener
          if (state is SignoutDashboardState) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 58.w),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    spacing: 20.w,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.w),
                          border: Border.all(
                            color: Color(0xFF8E8E8E),
                            width: 0.5.w,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                              'https://images.glints.com/unsafe/glints-dashboard.oss-ap-southeast-1-internal.aliyuncs.com/company-logo/09c50b1686df33c5a3e63f5cb141506e.jpg',
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.w,
                            child: Text(
                              "Good Morning,",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.inter128MediumSecondary,
                            ),
                          ),
                          Container(
                            width: 200.w,
                            child: Text(
                              "Livia Vacarro",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.inter16MediumPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10.w),
                    onTap: () => true,
                    child: Ink(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.w),
                        boxShadow: [AppShadows.shadow094],
                        color: AppColors.white,
                      ),
                      child: Icon(Icons.notifications),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateTime.now().toIndonesianString(),
                    style: AppTextStyles.inter96MediumPrimary,
                  ),
                  Container(
                    width: 156.w,
                    height: 26.w,
                    decoration: BoxDecoration(
                      color: AppColors.deepTeal,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                  ),
                ],
              ),
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
