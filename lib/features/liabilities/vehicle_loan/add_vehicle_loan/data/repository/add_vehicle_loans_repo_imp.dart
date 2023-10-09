import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/data/datasource/remote_add_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/params/add_vehicle_loans_params.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/domain/repository/add_vehicle_loans_repo.dart';

class AddVehicleLoansRepoImp implements AddVehicleLoansRepo {
  AddVehicleLoansRepoImp({required this.remoteAddVehicleLoansDataSource});

  final RemoteAddVehicleLoansDataSource remoteAddVehicleLoansDataSource;

  @override
  Future<Either<Failure, VehicleLoans>> addVehicleLoans(
      AddVehicleLoansParams params) async {
    try {
      final result = await remoteAddVehicleLoansDataSource
          .addVehicleLoans(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, VehicleLoans>> udpateVehicleLoans(
      AddVehicleLoansParams params) async {
    try {
      final result = await remoteAddVehicleLoansDataSource
          .updateVehicleLoans(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
