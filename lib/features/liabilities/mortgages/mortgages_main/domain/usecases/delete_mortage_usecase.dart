import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/repository/main_mortage_repo.dart';

class DeleteMortageUsecase extends UseCase<MortgagesEntity, DeleteParams> {
  DeleteMortageUsecase(this.mainMortageRepo);

  final MainMortageRepo mainMortageRepo;

  @override
  Future<Either<Failure, MortgagesEntity>> call(DeleteParams params) {
    return mainMortageRepo.deleteMortage(params);
  }
}
