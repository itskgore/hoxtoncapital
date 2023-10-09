import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/params/add_update_other_liabilities_params.dart';

abstract class AddUpdateOtherLiabilitiesRepo {
  Future<Either<Failure, OtherLiabilitiesEntity>> addOtherLiabilities(
      AddUpdateOtherLiabilitiesParams params);

  Future<Either<Failure, OtherLiabilitiesEntity>> updateOtherLiabilities(
      AddUpdateOtherLiabilitiesParams params);
}
