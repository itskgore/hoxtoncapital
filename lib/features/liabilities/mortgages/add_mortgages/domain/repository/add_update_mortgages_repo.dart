import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/domain/params/mortgages_params.dart';

abstract class AddUpdateMortgagesRepo {
  Future<Either<Failure, Mortgages>> addMortgages(AddMortgagesParams params);

  Future<Either<Failure, Mortgages>> updateMortgages(AddMortgagesParams params);
}
