import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investments_holdings_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/your_pensions/data/datasource/remote_your_pensions_datasource.dart';
import 'package:wedge/features/your_pensions/domain/repository/your_pension_repo.dart';

import '../model/pension_performance_model.dart';

class YourPensionRepoImp implements YourPensionRepo {
  final RemoteYourPension remoteYourInvestment;

  YourPensionRepoImp({required this.remoteYourInvestment});

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
  Future<Either<Failure, PensionPerformanceModel>> getPensionPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      required String id}) async {
    try {
      final result = await remoteYourInvestment.getPensionPerformance(
          merge, scope, fromDate, toDate, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
