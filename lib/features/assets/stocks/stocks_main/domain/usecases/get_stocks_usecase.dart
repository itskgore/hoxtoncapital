import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/stocks_main/domain/repositories/stocks_repository.dart';

class GetStocks implements UseCase<AssetsEntity, NoParams> {
  final StocksRepository repository;

  GetStocks(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getStocks();
  }
}
