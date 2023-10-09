import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/repository/search_stocks_repo.dart';

class GetStocksData extends UseCase<List<SearchStocksCryptoEntity>, String> {
  final SearchStocksRepo searchCryptoRepo;

  GetStocksData(this.searchCryptoRepo);

  @override
  Future<Either<Failure, List<SearchStocksCryptoEntity>>> call(String params) {
    return searchCryptoRepo.getStocksData(params);
  }
}
