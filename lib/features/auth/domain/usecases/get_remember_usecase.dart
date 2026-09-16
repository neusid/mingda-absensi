import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class GetRememberUsecase {
  final AuthRepository authRepository;
  GetRememberUsecase({required this.authRepository});

  Future<Either<Failure, AuthSessionEntity>> call() async {
    return await authRepository.getRememberRepository();
  }
}
