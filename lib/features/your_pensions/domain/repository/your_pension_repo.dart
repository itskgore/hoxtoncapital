import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/your_pensions/data/model/pension_performance_model.dart';

abstract class YourPensionRepo {
  Future<Either<Failure, List<InvestmentHoldingsEntity>>> getHoldings(
      {required String id, required String source});

  Future<Either<Failure, PensionPerformanceModel>> getPensionPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required String id});
}
