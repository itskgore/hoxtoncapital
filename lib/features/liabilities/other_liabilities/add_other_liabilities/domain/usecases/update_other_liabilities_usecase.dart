import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/params/add_update_other_liabilities_params.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/repository/add_update_other_liabilities_repo.dart';

class UpdateOtherLiabilitiesUsecase
    extends UseCase<OtherLiabilitiesEntity, AddUpdateOtherLiabilitiesParams> {
  UpdateOtherLiabilitiesUsecase(this.addUpdateOtherLiabilitiesRepo);

  final AddUpdateOtherLiabilitiesRepo addUpdateOtherLiabilitiesRepo;

  @override
  Future<Either<Failure, OtherLiabilitiesEntity>> call(
      AddUpdateOtherLiabilitiesParams params) {
    return addUpdateOtherLiabilitiesRepo.updateOtherLiabilities(params);
  }
}
