import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/data/data_sources/local_get_custom_assets_source.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/data/data_sources/remote_custom_assets_data_source.dart.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/repositories/custom_assets_repository.dart';

class CustomAssetsRepositoryImpl implements CustomAssetsRepository {
  final LocalCustomAssetsDataSource localDataSource;
  final RemoteCustomAssetsSource remoteCustomAssetsDataSource;

  CustomAssetsRepositoryImpl(
      {required this.localDataSource,
      required this.remoteCustomAssetsDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getCustomAssets() async {
    try {
      final result = await localDataSource.getCustomAssets();
      return Right(result);
    } on CacheFailure {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, OtherAssetsEntity>> deleteCustomAssets(
      String id) async {
    try {
      final result = await remoteCustomAssetsDataSource.deleteCustomAsset(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
