import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class SaveRememberUsecase {
  final AuthRepository authRepository;
  SaveRememberUsecase({required this.authRepository});

  Future<Either<Failure, bool>> call(AuthSessionEntity entity) async {
    try {
      await authRepository.saveRememberRepository(entity);
      return right(true);
    } catch (e) {
      return left(StorageWriteFailure(e.toString()));
    }
  }
}
