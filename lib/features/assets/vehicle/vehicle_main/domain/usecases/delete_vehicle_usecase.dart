import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/repositories/vehicles_repository.dart';

class DeleteVehicles implements UseCase<VehicleEntity, DeleteParams> {
  final VehicleRepository repository;

  DeleteVehicles(this.repository);

  @override
  Future<Either<Failure, VehicleEntity>> call(DeleteParams params) async {
    return await repository.deleteVehicle(params.id);
  }
}
