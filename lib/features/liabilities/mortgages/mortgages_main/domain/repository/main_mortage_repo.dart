import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

abstract class MainMortageRepo {
  Future<Either<Failure, LiabilitiesEntity>> getMortage();

  Future<Either<Failure, MortgagesEntity>> deleteMortage(DeleteParams params);

  Future<Either<Failure, bool>> unlinkMortage(UnlinkParams params);
}
