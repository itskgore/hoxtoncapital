import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class MainVehicleLoansRepo {
  Future<Either<Failure, LiabilitiesEntity>> getVehicleData();

  Future<Either<Failure, VehicleLoansEntity>> deleteVehicleData(String id);

  Future<Either<Failure, bool>> unlinkVehicleData(
      Map<String, dynamic> id, String vehicleId);
}
