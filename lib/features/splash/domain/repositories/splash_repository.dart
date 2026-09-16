import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';

abstract class SplashRepository {
  Future<Either<Failure, String>> GetToken();
  Future<Either<Failure, void>> CheckToken(String token);
}
