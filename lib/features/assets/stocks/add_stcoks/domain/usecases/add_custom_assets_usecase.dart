import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/repositories/add_stocks_repository.dart';

class AddStocksBonds
    implements UseCase<StocksAndBondsEntity, StocksBondsParams> {
  final AddStocksRepository repository;

  AddStocksBonds(this.repository);

  @override
  Future<Either<Failure, StocksAndBondsEntity>> call(
      StocksBondsParams params) async {
    return await repository.addStocks(
        params.name, params.quantity, params.value, params.symbol);
  }
}

class StocksBondsParams extends Equatable {
  final String name;
  final double quantity;
  final ValueEntity value;
  final String id;
  final String symbol;

  StocksBondsParams(
      {required this.name,
      required this.quantity,
      required this.symbol,
      required this.value,
      required this.id});

  @override
  List<Object> get props => [name, quantity, value, id, symbol];
}
