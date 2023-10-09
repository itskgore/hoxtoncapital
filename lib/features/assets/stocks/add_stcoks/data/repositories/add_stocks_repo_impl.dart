import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/data/data_sources/add_stocks_data_source.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/repositories/add_stocks_repository.dart';

class AddStocksBondsRepositoryImpl implements AddStocksRepository {
  final AddStocksDataSource addStocksBondsDataSource;

  AddStocksBondsRepositoryImpl({required this.addStocksBondsDataSource});

  @override
  Future<Either<Failure, StocksAndBondsEntity>> addStocks(
      String name, double quantity, ValueEntity value, String symbol) async {
    try {
      final verifiedUser = await addStocksBondsDataSource.addStocks(
          name, quantity, value, symbol);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, StocksAndBondsEntity>> updateStocks(String name,
      double quantity, ValueEntity value, String id, String symbol) async {
    try {
      final verifiedUser = await addStocksBondsDataSource.updateStocks(
          name, quantity, value, id, symbol);
      return Right(verifiedUser);
    } on ServerFailure {
      return Left(ServerFailure());
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
