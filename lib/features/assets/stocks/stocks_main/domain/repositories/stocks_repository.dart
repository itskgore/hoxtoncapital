import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../data/models/stocks_performance_model.dart';

abstract class StocksRepository {
  Future<Either<Failure, AssetsEntity>> getStocks();

  Future<Either<Failure, StocksAndBondsEntity>> deleteStocks(String id);

  Future<Either<Failure, StocksPerformanceModel>> getStocksPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      String? assetType,
      String? id});
}
