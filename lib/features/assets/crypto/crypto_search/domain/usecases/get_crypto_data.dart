import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/repository/search_crypto_repo.dart';

class GetCryptoData extends UseCase<List<SearchStocksCryptoEntity>, String> {
  final SearchCryptoRepo searchCryptoRepo;

  GetCryptoData(this.searchCryptoRepo);

  @override
  Future<Either<Failure, List<SearchStocksCryptoEntity>>> call(String params) {
    return searchCryptoRepo.getCryptoData(params);
  }
}
