import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../data/Models/assets_liabilities_model.dart';

abstract class GetAllAssetsLiabilitiesRepository {
  Future<Either<Failure, AssetsEntity>> getAssets();

  Future<Either<Failure, LiabilitiesEntity>> getLiabilities();

  Future<Either<Failure, AssetsLiabilitiesModel>> getAssetsLiabilities();
}
