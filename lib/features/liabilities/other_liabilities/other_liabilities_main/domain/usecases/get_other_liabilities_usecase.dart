import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/repository/main_other_liabilities_repo.dart';

class GetOtherLiabilitiesUsecase extends UseCase<LiabilitiesEntity, NoParams> {
  GetOtherLiabilitiesUsecase(this.mainOtherRepositoryRepo);

  final MainOtherRepositoryRepo mainOtherRepositoryRepo;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) {
    return mainOtherRepositoryRepo.getOtherLiabilities();
  }
}
