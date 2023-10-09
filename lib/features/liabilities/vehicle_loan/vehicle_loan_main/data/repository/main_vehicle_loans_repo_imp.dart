import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/data/datasource/local_main_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/data/datasource/remote_main_vehicle_loans.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/domain/repository/main_vehicle_loans.dart';

class MainVehicleLoansRepoImp implements MainVehicleLoansRepo {
  MainVehicleLoansRepoImp(
      {required this.localMainVehicleLoans,
      required this.remoteVehicleLoans,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  final LocalMainVehicleLoans localMainVehicleLoans;
  final RemoteVehicleLoans remoteVehicleLoans;
  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  @override
  Future<Either<Failure, VehicleLoansEntity>> deleteVehicleData(
      String id) async {
    try {
      final result = await remoteVehicleLoans.deleteVehicleLoans(id);
      // Refresh Assets for Vehicles
      final data = await assetsLiabilitiesdataSource.getMainAssets();
      await localAssetsLiabilitiesDataSource.saveAssetsLiabilities(data);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getVehicleData() async {
    try {
      final result = await localMainVehicleLoans.getVehicleData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkVehicleData(
      Map<String, dynamic> id, String vehicleId) async {
    try {
      final result = await remoteVehicleLoans.unlinkVehicleLoans(id, vehicleId);
      // Refresh Assets for Vehicles
      final data = await assetsLiabilitiesdataSource.getMainAssets();
      await localAssetsLiabilitiesDataSource.saveAssetsLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
