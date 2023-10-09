import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/stocks/stocks_main/data/data_sources/local_get_stocks_source.dart';
import 'package:wedge/features/assets/stocks/stocks_main/data/data_sources/remote_stocks_data_source.dart.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/repositories/stocks_repository.dart';

import '../models/stocks_performance_model.dart';

class StocksRepositoryImpl implements StocksRepository {
  final LocalStocksDataSource localDataSource;
  final RemoteStocksSource remoteStocksDataSource;

  StocksRepositoryImpl(
      {required this.localDataSource, required this.remoteStocksDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getStocks() async {
    try {
      final result = await localDataSource.getStocks();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, StocksAndBondsEntity>> deleteStocks(String id) async {
    try {
      final result = await remoteStocksDataSource.deleteStock(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, StocksPerformanceModel>> getStocksPerformance({
    required bool merge,
    required List scope,
    required String fromDate,
    required String toDate,
    String? assetType,
    String? id,
  }) async {
    try {
      final result = await remoteStocksDataSource.getStocksPerformance(
          merge: merge,
          scope: scope,
          fromDate: fromDate,
          toDate: toDate,
          assetType: assetType,
          id: id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
