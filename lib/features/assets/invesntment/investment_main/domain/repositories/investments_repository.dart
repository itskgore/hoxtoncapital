import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class InvestmentRepository {
  Future<Either<Failure, AssetsEntity>> getInvestments();

  Future<Either<Failure, InvestmentEntity>> deleteInvestment(String id);
}
