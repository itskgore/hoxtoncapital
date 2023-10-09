import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/data/data_sources/add_custom_assets_data_source.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/repositories/add_custom_assets_repository.dart';

class AddCustomAssetsRepositoryImpl implements AddCustomAssetsRepository {
  final AddCustomAssetsDataSource addCustomAssetsDataSource;

  AddCustomAssetsRepositoryImpl({required this.addCustomAssetsDataSource});

  @override
  Future<Either<Failure, OtherAssetsEntity>> addCustomAssets(
      String name, String country, String type, ValueEntity value) async {
    // TODO: implement AddCustomAssets
    try {
      final verifiedUser = await addCustomAssetsDataSource.addCustomAssets(
          name, country, type, value);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, OtherAssetsEntity>> updateCustomAssets(String name,
      String country, String type, ValueEntity currentAmount, String id) async {
    try {
      final verifiedUser = await addCustomAssetsDataSource.updateCustomAssets(
          name, country, type, currentAmount, id);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
