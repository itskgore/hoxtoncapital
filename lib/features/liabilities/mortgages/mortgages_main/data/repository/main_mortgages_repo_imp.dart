import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/data/datasoource/local_main_mortage.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/data/datasoource/remote_main_mortage.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/domain/repository/main_mortage_repo.dart';

class MainMortageRepoImp implements MainMortageRepo {
  MainMortageRepoImp(
      {required this.localMainMortage,
      required this.remoteMortage,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  final LocalMainMortage localMainMortage;
  final RemoteMortage remoteMortage;
  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  @override
  Future<Either<Failure, MortgagesEntity>> deleteMortage(
      DeleteParams params) async {
    try {
      final result = await remoteMortage.deleteMoratgages(params.id);
      // Refresh the Assets
      // final data = await assetsLiabilitiesdataSource.getMainAssets();
      // await localAssetsLiabilitiesDataSource.saveAssetsLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesModel>> getMortage() async {
    try {
      final result = await localMainMortage.getMortageData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkMortage(UnlinkParams params) async {
    try {
      final result = await remoteMortage
          .unlinkMoratgages({"id": params.loanId}, params.vehicleId);
      // Refresh the Assets
      final data = await assetsLiabilitiesdataSource.getMainAssets();
      await localAssetsLiabilitiesDataSource.saveAssetsLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
