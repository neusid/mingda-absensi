import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/dashboard/domain/repositories/dashboard_repository.dart';

class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

class ChangePasswordUsecase {
  final DashboardRepository dashboardRepository;

  ChangePasswordUsecase({required this.dashboardRepository});

  Future<Either<Failure, void>> call(ChangePasswordParams params) async {
    final current = params.currentPassword.trim();
    final newPass = params.newPassword.trim();
    final confirm = params.confirmPassword.trim();

    if (current.isEmpty) {
      return const Left(ValidationFailure('Password saat ini wajib diisi'));
    }
    if (newPass.isEmpty) {
      return const Left(ValidationFailure('Password baru wajib diisi'));
    }
    if (newPass.length < 8) {
      return const Left(ValidationFailure('Password baru minimal 8 karakter'));
    }
    if (confirm.isEmpty) {
      return const Left(ValidationFailure('Konfirmasi password wajib diisi'));
    }
    if (newPass != confirm) {
      return const Left(ValidationFailure('Konfirmasi password tidak cocok dengan password baru'));
    }
    if (newPass == current) {
      return const Left(ValidationFailure('Password baru tidak boleh sama dengan password saat ini'));
    }

    return await dashboardRepository.changePassword(
      currentPassword: current,
      newPassword: newPass,
      confirmPassword: confirm,
    );
  }
}
