import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class SignoutUsecase {
  final DashboardRepository dashboardRepository;
  SignoutUsecase({required this.dashboardRepository});

  Future<Either<Failure, void>> call() async {
    return await dashboardRepository.signOut();
  }
}
