import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/assets/properties/properties_main/data/data_sources/local_get_properties_source.dart';
import 'package:wedge/features/assets/properties/properties_main/data/data_sources/remote_properties_data_source.dart.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/repositories/properties_repository.dart';

class PropertiesRepositoryImpl implements PropertiesRepository {
  final LocalPropertiesDataSource localDataSource;
  final RemotePropertiesSource remotePropertiesDataSource;
  final AssetsLiabilitiesdataSource assetsLiabilitiesdataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  PropertiesRepositoryImpl(
      {required this.localDataSource,
      required this.remotePropertiesDataSource,
      required this.assetsLiabilitiesdataSource,
      required this.localAssetsLiabilitiesDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getProperties() async {
    try {
      final result = await localDataSource.getProperties();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> deleteProperties(String id) async {
    try {
      final result = await remotePropertiesDataSource.deleteProperty(id);
      // Refresh Liabilities
      final data = await assetsLiabilitiesdataSource.getMainLiabilities();
      await localAssetsLiabilitiesDataSource.saveLiabilities(data);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> unlinkProperties(UnlinkParams params) async {
    try {
      final result = await remotePropertiesDataSource.unLinkProperty(params);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
