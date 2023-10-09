import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/data/data_sources/local_get_vehicles_source.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/data/data_sources/remote_vehicles_data_source.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/domain/repositories/vehicles_repository.dart';

class VehiclesRepositoryImpl implements VehicleRepository {
  final LocalVehiclesDataSource localDataSource;
  final RemoteVehiclesSource remoteDataSource;
  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  VehiclesRepositoryImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getVehicles() async {
    try {
      final result = await localDataSource.getVehicles();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> deleteVehicle(String id) async {
    try {
      final result = await remoteDataSource.deleteVehicle(id);
      // Refresh Liabilities
      final data = await assetsLiabilitiesdataSource.getMainLiabilities();
      await localAssetsLiabilitiesDataSource.saveLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> unLinkVehicle(UnlinkParams params) async {
    try {
      final result = await remoteDataSource.unlinkVehicle(params);
      // Refresh Liabilities
      final data = await assetsLiabilitiesdataSource.getMainLiabilities();
      await localAssetsLiabilitiesDataSource.saveLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
