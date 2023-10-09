import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddLiabilitiesRepo {
  Future<Either<Failure, LiabilitiesEntity>> getLiabilities();
}
