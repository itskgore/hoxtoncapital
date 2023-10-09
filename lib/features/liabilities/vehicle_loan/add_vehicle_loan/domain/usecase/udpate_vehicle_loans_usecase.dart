import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/repository/add_vehicle_loans_repo.dart';

class UpdateVehicleLoansUsecase
    extends UseCase<VehicleLoans, AddVehicleLoansParams> {
  UpdateVehicleLoansUsecase(this.addVehicleLoansRepo);

  final AddVehicleLoansRepo addVehicleLoansRepo;

  @override
  Future<Either<Failure, VehicleLoans>> call(AddVehicleLoansParams params) {
    return addVehicleLoansRepo.udpateVehicleLoans(params);
  }
}
