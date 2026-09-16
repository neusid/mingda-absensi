import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class SavetokenUsecase {
  final AuthRepository authRepository;
  SavetokenUsecase({required this.authRepository});

  Future<Either<Failure, void>> call(String token) async {
    return await authRepository.SaveToken(token);
  }
}
