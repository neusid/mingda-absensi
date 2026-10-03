import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/entities/profile_entity.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class UpdateProfileUsecase {
  final DashboardRepository dashboardRepository;
  UpdateProfileUsecase({required this.dashboardRepository});

  Future<Either<Failure, ProfileEntity>> call(ProfileEntity profile) async {
    return await dashboardRepository.updateProfile(profile);
  }
}
