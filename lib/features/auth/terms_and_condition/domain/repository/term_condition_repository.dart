import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class TermConditionRepository {
  Future<Either<Failure, bool>> acceptTermCondition();
}
