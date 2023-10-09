import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/repositories/stocks_repository.dart';

import '../../data/models/stocks_performance_model.dart';

class DeleteStocksBonds implements UseCase<StocksAndBondsEntity, DeleteParams> {
  final StocksRepository repository;

  DeleteStocksBonds(this.repository);

  @override
  Future<Either<Failure, StocksAndBondsEntity>> call(
      DeleteParams params) async {
    return await repository.deleteStocks(params.id);
  }
}

class GetStocksPerformance
    extends UseCase<StocksPerformanceModel, Map<String, dynamic>> {
  late StocksRepository stocksRepository;

  GetStocksPerformance(this.stocksRepository);

  @override
  Future<Either<Failure, StocksPerformanceModel>> call(
      Map<String, dynamic> params) {
    return stocksRepository.getStocksPerformance(
      merge: params['merge'],
      scope: params['scope'],
      fromDate: params['fromDate'],
      toDate: params['toDate'],
      assetType: params['assetType'],
      id: params['id'],
    );
  }
}
