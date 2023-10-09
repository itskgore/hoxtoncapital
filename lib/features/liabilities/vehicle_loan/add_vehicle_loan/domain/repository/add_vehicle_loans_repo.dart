import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';

abstract class AddVehicleLoansRepo {
  Future<Either<Failure, VehicleLoans>> addVehicleLoans(
      AddVehicleLoansParams params);

  Future<Either<Failure, VehicleLoans>> udpateVehicleLoans(
      AddVehicleLoansParams params);
}
