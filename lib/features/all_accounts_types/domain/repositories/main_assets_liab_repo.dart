import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AssetsLiabilitiesMainRepository {
  Future<Either<Failure, AssetsEntity>> getMainAssets();

  Future<Either<Failure, LiabilitiesEntity>> getMainLiabilities();
}
