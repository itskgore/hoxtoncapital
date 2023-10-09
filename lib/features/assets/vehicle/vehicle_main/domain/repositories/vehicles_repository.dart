import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

abstract class VehicleRepository {
  Future<Either<Failure, AssetsEntity>> getVehicles();

  Future<Either<Failure, VehicleEntity>> deleteVehicle(String id);

  Future<Either<Failure, bool>> unLinkVehicle(UnlinkParams params);
}
