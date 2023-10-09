import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddCustomAssetsRepository {
  Future<Either<Failure, OtherAssetsEntity>> addCustomAssets(
      String name, String country, String type, ValueEntity value);

  Future<Either<Failure, OtherAssetsEntity>> updateCustomAssets(
      String name, String country, String type, ValueEntity value, String id);
}
