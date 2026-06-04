import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';
import 'package:mingda_app/features/auth/data/models/user_model.dart';
import 'package:mingda_app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:mingda_app/features/auth/domain/entities/login_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> saveRememberRepository(AuthSessionEntity value);
  Future<Either<Failure, bool?>> getRememberRepository();
  Future<Either<Failure, bool?>> removeSessionRepository();

  Future<Either<Failure, LoginEntity>> SignIn({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> SignOut({required String token});

  Future<Either<Failure, void>> SaveToken(String token);
  Future<Either<Failure, void>> SaveUser(UserModel user);
}
