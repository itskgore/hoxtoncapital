import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/data/data_sources/add_vehicle_data_source.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/repositories/add_vehicle_repository.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/domain/usecases/add_vehicle_usecase.dart';

class AddVehicleRepositoryImpl implements AddVehicleRepository {
  final AddVehicleDataSource addVehicleDataSource;
  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  AddVehicleRepositoryImpl(
      {required this.addVehicleDataSource,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  @override
  Future<Either<Failure, VehicleEntity>> addVehicle(
      VehicleParams params) async {
    try {
      final data = await addVehicleDataSource.addVehicle(params.toJson());
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> updateVehicle(
      VehicleParams params) async {
    try {
      final verifiedUser =
          await addVehicleDataSource.updateVehicle(params.toJson());
      // Refresh Liabilities
      final data = await assetsLiabilitiesdataSource.getMainLiabilities();
      await localAssetsLiabilitiesDataSource.saveLiabilities(data);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
