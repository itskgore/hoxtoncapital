import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/your_investments/data/datasource/remote_your_investment_datasource.dart';
import 'package:wedge/features/your_investments/domain/repository/your_investment_repo.dart';

import '../model/Investment_performance_model.dart';

class YourInvestmentRepoImp implements YourInvestmentRepo {
  final RemoteYourInvestment remoteYourInvestment;

  YourInvestmentRepoImp({required this.remoteYourInvestment});

  @override
  Future<Either<Failure, List<InvestmentHoldingsEntity>>> getHoldings(
      {required String id, required String source}) async {
    try {
      final result = await remoteYourInvestment.getHoldings(id, source);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, InvestmentPerformanceModel>> getInvestmentPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required String id}) async {
    try {
      final result = await remoteYourInvestment.getInvestmentPerformance(
          merge, scope, fromDate, toDate, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
