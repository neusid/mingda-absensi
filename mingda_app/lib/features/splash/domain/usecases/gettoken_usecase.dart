import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/splash/domain/repositories/splash_repository.dart';

class GettokenUsecase {
  final SplashRepository splashRepository;
  GettokenUsecase({required this.splashRepository});

  Future<Either<Failure, String>> call() async {
    final resultGetToken = await splashRepository.GetToken();

    return resultGetToken.fold((f) => Left(f), (r) => Right(r));
  }
}
