import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/repositories/vehicles_repository.dart';

class GetVehicless implements UseCase<AssetsEntity, NoParams> {
  final VehicleRepository repository;

  GetVehicless(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getVehicles();
  }
}
