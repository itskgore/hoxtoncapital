import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/your_investments/domain/repository/your_investment_repo.dart';

import '../../data/model/Investment_performance_model.dart';

class GetHoldings
    extends UseCase<List<InvestmentHoldingsEntity>, Map<String, dynamic>> {
  final YourInvestmentRepo yourInvestmentRepo;

  GetHoldings(this.yourInvestmentRepo);

  @override
  Future<Either<Failure, List<InvestmentHoldingsEntity>>> call(
      Map<String, dynamic> params) {
    return yourInvestmentRepo.getHoldings(
        id: params['id'], source: params['source']);
  }
}

class GetInvestmentPerformance
    extends UseCase<InvestmentPerformanceModel, Map<String, dynamic>> {
  final YourInvestmentRepo yourInvestmentRepo;

  GetInvestmentPerformance(this.yourInvestmentRepo);

  @override
  Future<Either<Failure, InvestmentPerformanceModel>> call(
      Map<String, dynamic> params) {
    return yourInvestmentRepo.getInvestmentPerformance(
        merge: params['merge'],
        scope: params['scope'],
        fromDate: params['fromDate'],
        toDate: params['toDate'],
        id: params['id']);
  }
}
