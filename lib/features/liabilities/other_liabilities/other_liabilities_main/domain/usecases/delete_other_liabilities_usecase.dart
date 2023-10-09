import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/repository/main_other_liabilities_repo.dart';

class DeleteOtherLiabilitiesUsecase
    extends UseCase<OtherLiabilitiesEntity, DeleteParams> {
  DeleteOtherLiabilitiesUsecase(this.mainOtherRepositoryRepo);

  final MainOtherRepositoryRepo mainOtherRepositoryRepo;

  @override
  Future<Either<Failure, OtherLiabilitiesEntity>> call(DeleteParams params) {
    return mainOtherRepositoryRepo.deleteOtherLiabilities(params.id);
  }
}
