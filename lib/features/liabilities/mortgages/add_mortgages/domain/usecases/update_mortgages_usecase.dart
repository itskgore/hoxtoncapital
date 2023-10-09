import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/params/mortgages_params.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/repository/add_update_mortgages_repo.dart';

class UpdateMortgagesUsecases extends UseCase<Mortgages, AddMortgagesParams> {
  UpdateMortgagesUsecases(this.addUpdateMortgagesRepo);

  final AddUpdateMortgagesRepo addUpdateMortgagesRepo;

  @override
  Future<Either<Failure, Mortgages>> call(AddMortgagesParams params) {
    return addUpdateMortgagesRepo.updateMortgages(params);
  }
}
