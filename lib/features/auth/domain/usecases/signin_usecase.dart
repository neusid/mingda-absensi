import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class SigninUsecase {
  final AuthRepository authRepository;
  SigninUsecase(this.authRepository);

  Future<Either<Failure, void>> call(LoginParams params) async {
    if (params.email.isEmpty) {
      return Left(ValidationFailure('Email tidak boleh kosong'));
    }

    if (params.password.isEmpty) {
      return const Left(ValidationFailure('Password tidak boleh kosong'));
    }

    if (!_isValidEmail(params.email)) {
      return const Left(ValidationFailure('Format email tidak valid'));
    }

    if (params.password.length < 8) {
      return const Left(ValidationFailure('Password minimal 8 karakter'));
    }

    final loginEntity = await authRepository.SignIn(
      email: params.email,
      password: params.password,
    );

    return loginEntity.fold((l) => Left(l), (r) async {
      await authRepository.SaveToken(r.token);
      await authRepository.SaveUser(r.userModel);

      return right(null);
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
