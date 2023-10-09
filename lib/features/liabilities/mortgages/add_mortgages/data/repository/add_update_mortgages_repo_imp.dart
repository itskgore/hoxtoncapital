import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/data/datasource/add_update_mortgages_datasource.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/params/mortgages_params.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/repository/add_update_mortgages_repo.dart';

class AddUpdateMortgagesRepoImp implements AddUpdateMortgagesRepo {
  AddUpdateMortgagesRepoImp(
      {required this.addUpdateMortgagesDataSource,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;
  final AddUpdateMortgagesDataSource addUpdateMortgagesDataSource;

  @override
  Future<Either<Failure, Mortgages>> addMortgages(
      AddMortgagesParams params) async {
    try {
      final result =
          await addUpdateMortgagesDataSource.addMortgages(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Mortgages>> updateMortgages(
      AddMortgagesParams params) async {
    try {
      final result =
          await addUpdateMortgagesDataSource.updateMortgages(params.toJson());
      // Refresh Asset
      final data = await assetsLiabilitiesdataSource.getMainAssets();
      await localAssetsLiabilitiesDataSource.saveAssetsLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
