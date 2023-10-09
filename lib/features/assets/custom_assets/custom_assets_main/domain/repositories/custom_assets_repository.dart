import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CustomAssetsRepository {
  Future<Either<Failure, AssetsEntity>> getCustomAssets();

  Future<Either<Failure, OtherAssetsEntity>> deleteCustomAssets(String id);
}
