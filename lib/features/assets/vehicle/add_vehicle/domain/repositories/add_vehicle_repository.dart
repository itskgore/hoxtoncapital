import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/usecases/add_vehicle_usecase.dart';

abstract class AddVehicleRepository {
  Future<Either<Failure, VehicleEntity>> addVehicle(VehicleParams params);

  Future<Either<Failure, VehicleEntity>> updateVehicle(VehicleParams params);
}
