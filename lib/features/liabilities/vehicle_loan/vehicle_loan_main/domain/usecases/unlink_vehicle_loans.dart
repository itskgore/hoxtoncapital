import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/repository/main_vehicle_loans.dart';

class UnlinkVehicleLoans extends UseCase<bool, UnlinkParams> {
  UnlinkVehicleLoans(this.mainVehicleLoansRepo);

  final MainVehicleLoansRepo mainVehicleLoansRepo;

  @override
  Future<Either<Failure, bool>> call(
    UnlinkParams params,
  ) {
    return mainVehicleLoansRepo
        .unlinkVehicleData({"id": params.loanId}, params.vehicleId);
  }
}
