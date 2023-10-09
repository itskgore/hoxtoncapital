import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/repository/main_vehicle_loans.dart';

class GetVehicleLoansUsecase extends UseCase<LiabilitiesEntity, NoParams> {
  GetVehicleLoansUsecase(this.mainVehicleRepo);

  final MainVehicleLoansRepo mainVehicleRepo;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) {
    return mainVehicleRepo.getVehicleData();
  }
}
