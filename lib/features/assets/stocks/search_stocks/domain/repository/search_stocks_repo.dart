import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class SearchStocksRepo {
  Future<Either<Failure, List<SearchStocksCryptoEntity>>> getStocksData(
      String parameter);

  Future<Either<Failure, Map<String, dynamic>>> getStocksCurrency(
      String parameter);
}
