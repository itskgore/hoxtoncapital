import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetAllAssetsRepository {
  Future<Either<Failure, AssetsEntity>> getAssets();
}
