import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/repository/main_vehicle_loans.dart';

class DeleteVehicleLoansUsecase
    extends UseCase<VehicleLoansEntity, DeleteParams> {
  DeleteVehicleLoansUsecase(this.mainVehicleRepo);

  final MainVehicleLoansRepo mainVehicleRepo;

  @override
  Future<Either<Failure, VehicleLoansEntity>> call(DeleteParams params) {
    return mainVehicleRepo.deleteVehicleData(params.id);
  }
}
