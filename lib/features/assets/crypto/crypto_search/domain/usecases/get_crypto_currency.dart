import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/repository/search_crypto_repo.dart';

class GetCryptoCurrency extends UseCase<Map<String, dynamic>, String> {
  final SearchCryptoRepo searchCryptoRepo;

  GetCryptoCurrency(this.searchCryptoRepo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String params) {
    return searchCryptoRepo.getCryptoCurrency(params);
  }
}
