import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/repositories/vehicles_repository.dart';

class UnlinkVehicleUsecase implements UseCase<bool, UnlinkParams> {
  final VehicleRepository repository;

  UnlinkVehicleUsecase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnlinkParams params) async {
    return await repository.unLinkVehicle(params);
  }
}
