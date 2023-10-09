import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/domain/repositories/add_stocks_repository.dart';

import 'add_custom_assets_usecase.dart';

class UpdateStocksBonds
    implements UseCase<StocksAndBondsEntity, StocksBondsParams> {
  final AddStocksRepository repository;

  UpdateStocksBonds(this.repository);

  @override
  Future<Either<Failure, StocksAndBondsEntity>> call(
      StocksBondsParams params) async {
    return await repository.updateStocks(
        params.name, params.quantity, params.value, params.id, params.symbol);
  }
}
