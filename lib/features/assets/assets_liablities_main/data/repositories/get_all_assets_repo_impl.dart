import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/assets_liablities_main/data/data_sources/local_get_all_assets_data_source.dart';
import 'package:wedge/features/assets/assets_liablities_main/data/data_sources/remote_get_all_assets_data_sorce.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/repositories/get_all_assets_repository.dart';

import '../Models/assets_liabilities_model.dart';

class GetAllAssetsLiabilitiesRepositoryImpl
    implements GetAllAssetsLiabilitiesRepository {
  final MainAssetsLiabilitiesdataSource dataSource;
  final MainLocalAssetsLiabilitiesDataSource localDatasource;

  GetAllAssetsLiabilitiesRepositoryImpl(
      {required this.dataSource, required this.localDatasource});

  @override
  Future<Either<Failure, AssetsEntity>> getAssets() async {
    try {
      final result = await dataSource.getMainAssets();
      await localDatasource.saveAssets(result);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getLiabilities() async {
    try {
      final result = await dataSource.getMainLiabilities();
      localDatasource.saveLiabilities(result);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, AssetsLiabilitiesModel>> getAssetsLiabilities() async {
    try {
      final result = await localDatasource.getMainAssetsLiabilities();
      localDatasource.saveAssetsLiabilities(result);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
