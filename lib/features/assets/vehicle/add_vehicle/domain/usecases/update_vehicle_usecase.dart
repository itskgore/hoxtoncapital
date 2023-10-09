import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/repositories/add_vehicle_repository.dart';

import 'add_vehicle_usecase.dart';

class UpdateVehicle implements UseCase<VehicleEntity, VehicleParams> {
  final AddVehicleRepository repository;

  UpdateVehicle(this.repository);

  @override
  Future<Either<Failure, VehicleEntity>> call(VehicleParams params) async {
    return await repository.updateVehicle(params);
  }
}
