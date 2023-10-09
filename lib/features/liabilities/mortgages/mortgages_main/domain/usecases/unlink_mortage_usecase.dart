import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/repository/main_mortage_repo.dart';

class UnlinkMortageUsecase extends UseCase<bool, UnlinkParams> {
  UnlinkMortageUsecase(this.mainMortageRepo);

  final MainMortageRepo mainMortageRepo;

  @override
  Future<Either<Failure, bool>> call(UnlinkParams params) {
    return mainMortageRepo.unlinkMortage(params);
  }
}
