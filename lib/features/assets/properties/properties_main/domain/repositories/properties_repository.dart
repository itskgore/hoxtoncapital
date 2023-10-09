import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

abstract class PropertiesRepository {
  Future<Either<Failure, AssetsEntity>> getProperties();

  Future<Either<Failure, PropertyEntity>> deleteProperties(String id);

  Future<Either<Failure, bool>> unlinkProperties(UnlinkParams params);
}
