import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/repository/main_mortage_repo.dart';

class GetMortageUsecase extends UseCase<LiabilitiesEntity, NoParams> {
  GetMortageUsecase(this.mainMortageRepo);

  final MainMortageRepo mainMortageRepo;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) {
    return mainMortageRepo.getMortage();
  }
}
