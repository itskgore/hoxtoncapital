import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/repository/add_vehicle_loans_repo.dart';

class AddVehicleLoansUsecase
    extends UseCase<VehicleLoansEntity, AddVehicleLoansParams> {
  AddVehicleLoansUsecase(this.addVehicleLoansRepo);

  final AddVehicleLoansRepo addVehicleLoansRepo;

  @override
  Future<Either<Failure, VehicleLoansEntity>> call(
      AddVehicleLoansParams params) {
    return addVehicleLoansRepo.addVehicleLoans(params);
  }
}
