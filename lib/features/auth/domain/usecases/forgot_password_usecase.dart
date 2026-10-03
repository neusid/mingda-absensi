import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository authRepository;

  const ForgotPasswordUseCase({required this.authRepository});

  Future<Either<Failure, String>> call(String email) async {
    return await authRepository.forgotPassword(email: email);
  }
}
