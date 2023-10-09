import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/stocks_crypto_search_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class SearchCryptoRepo {
  Future<Either<Failure, List<SearchStocksCryptoModel>>> getCryptoData(
      String parameter);

  Future<Either<Failure, Map<String, dynamic>>> getCryptoCurrency(
      String parameter);
}
