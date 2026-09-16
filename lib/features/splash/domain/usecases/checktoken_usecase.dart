import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';

class CheckTokenUsecase {
  final SplashRepository splashRepository;
  CheckTokenUsecase({required this.splashRepository});

  Future<Either<Failure, void>> call(String token) async {
    return await splashRepository.CheckToken(token);
  }
}
