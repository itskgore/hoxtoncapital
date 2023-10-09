import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class MainPensionsRepository {
  Future<Either<Failure, AssetsEntity>> getPensions();

  Future<Either<Failure, PensionsEntity>> deletePension(String id);
}
