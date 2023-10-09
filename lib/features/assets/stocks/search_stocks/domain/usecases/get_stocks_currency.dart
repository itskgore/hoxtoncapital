import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/repository/search_stocks_repo.dart';

class GetStocksCurrency extends UseCase<Map<String, dynamic>, String> {
  final SearchStocksRepo searchCryptoRepo;

  GetStocksCurrency(this.searchCryptoRepo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String params) {
    return searchCryptoRepo.getStocksCurrency(params);
  }
}
