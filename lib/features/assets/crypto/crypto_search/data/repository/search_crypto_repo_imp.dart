import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/stocks_crypto_search_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/crypto_search/data/datasource/remote_search_crypto.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/repository/search_crypto_repo.dart';

class SearchCryptoRepoImp implements SearchCryptoRepo {
  final RemoteSearchCrypto remoteSearchCrypto;

  SearchCryptoRepoImp({required this.remoteSearchCrypto});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCryptoCurrency(
      String parameter) async {
    try {
      final result = await remoteSearchCrypto.getCryptoCurrency(parameter);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<SearchStocksCryptoModel>>> getCryptoData(
      String parameter) async {
    try {
      final result = await remoteSearchCrypto.getCryptoData(parameter);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
