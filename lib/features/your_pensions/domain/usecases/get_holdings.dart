import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/your_pensions/domain/repository/your_pension_repo.dart';

import '../../data/model/pension_performance_model.dart';

class GetHoldingsPension
    extends UseCase<List<InvestmentHoldingsEntity>, Map<String, dynamic>> {
  final YourPensionRepo yourInvestmentRepo;

  GetHoldingsPension(this.yourInvestmentRepo);

  @override
  Future<Either<Failure, List<InvestmentHoldingsEntity>>> call(
      Map<String, dynamic> params) {
    return yourInvestmentRepo.getHoldings(
        id: params['id'], source: params['source']);
  }
}

class GetPensionPerformance
    extends UseCase<PensionPerformanceModel, Map<String, dynamic>> {
  final YourPensionRepo yourInvestmentRepo;

  GetPensionPerformance(this.yourInvestmentRepo);

  @override
  Future<Either<Failure, PensionPerformanceModel>> call(
      Map<String, dynamic> params) {
    return yourInvestmentRepo.getPensionPerformance(
      merge: params['merge'],
      scope: params['scope'],
      fromDate: params['fromDate'],
      toDate: params['toDate'],
      id: params['id'],
    );
  }
}
