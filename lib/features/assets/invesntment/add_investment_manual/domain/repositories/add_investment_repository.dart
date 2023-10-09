import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';

import 'package:wedge/core/error/failures.dart';

abstract class AddInvestmentRepository {
  Future<Either<Failure, InvestmentEntity>> addInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue);

  Future<Either<Failure, InvestmentEntity>> updateInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue);
}
