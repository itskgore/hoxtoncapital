import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class MainOtherRepositoryRepo {
  Future<Either<Failure, LiabilitiesEntity>> getOtherLiabilities();

  Future<Either<Failure, OtherLiabilitiesEntity>> deleteOtherLiabilities(
      String id);
}
