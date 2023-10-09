import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/stocks_crypto_search_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/stocks/search_stocks/data/datasource/remote_search_stocks.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/repository/search_stocks_repo.dart';

class SearchStocksRepoImp implements SearchStocksRepo {
  final RemoteSearchStocks remoteSearchStocks;

  SearchStocksRepoImp({required this.remoteSearchStocks});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getStocksCurrency(
      String parameter) async {
    try {
      final result = await remoteSearchStocks.getStocksCurrency(parameter);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<SearchStocksCryptoModel>>> getStocksData(
      String parameter) async {
    try {
      final result = await remoteSearchStocks.getStocksData(parameter);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
