import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/all_accounts_types/domain/repositories/main_assets_liab_repo.dart';

class GetAssetsLiabilitiesMainRepositoryImpl
    implements AssetsLiabilitiesMainRepository {
  final AssetsLiabilitiesdataSource assetsDatasorce;
  final LocalAssetsLiabilitiesDataSource localassetsLiabilitiesDataSource;

  GetAssetsLiabilitiesMainRepositoryImpl(
      {required this.assetsDatasorce,
      required this.localassetsLiabilitiesDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getMainAssets() async {
    try {
      final result = await assetsDatasorce.getMainAssets();
      await localassetsLiabilitiesDataSource.saveAssetsLiabilities(result);

      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getMainLiabilities() async {
    try {
      final result = await assetsDatasorce.getMainLiabilities();
      await localassetsLiabilitiesDataSource.saveLiabilities(result);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
