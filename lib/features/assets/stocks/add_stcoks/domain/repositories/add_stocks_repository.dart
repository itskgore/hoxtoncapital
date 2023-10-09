import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddStocksRepository {
  Future<Either<Failure, StocksAndBondsEntity>> addStocks(
      String name, double quantity, ValueEntity value, String symbol);

  Future<Either<Failure, StocksAndBondsEntity>> updateStocks(String name,
      double quantity, ValueEntity value, String id, String symbol);
}
