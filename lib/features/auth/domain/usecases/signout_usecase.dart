import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class SignoutUsecase {
  final AuthRepository authRepository;
  SignoutUsecase({required this.authRepository});

  Future<Either<Failure, void>> call(String token) async {
    if (token.isEmpty) {
      return left(ValidationFailure('Token tidak tersedia.'));
    }

    return right(authRepository.SignOut(token: token));
  }
}
