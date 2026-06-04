import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/domain/repositories/auth_repository.dart';

class RemoveAuthSessionUsecase {
  final AuthRepository authRepository;
  RemoveAuthSessionUsecase({required this.authRepository});

  Future<Either<Failure, bool>> call() async {
    try {
      await authRepository.removeSessionRepository();
      return right(true);
    } catch (e) {
      return left(StorageWriteFailure(e.toString()));
    }
  }
}
