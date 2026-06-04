import 'package:dartz/dartz.dart';
import 'package:mingda_app/core/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, void>> signOut();
}
