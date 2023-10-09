import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../data/model/Investment_performance_model.dart';

abstract class YourInvestmentRepo {
  Future<Either<Failure, List<InvestmentHoldingsEntity>>> getHoldings(
      {required String id, required String source});

  Future<Either<Failure, InvestmentPerformanceModel>> getInvestmentPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required String id});
}
