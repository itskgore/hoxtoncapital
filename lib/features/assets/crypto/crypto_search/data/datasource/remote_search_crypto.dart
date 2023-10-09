import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/stocks_crypto_search_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteSearchCrypto {
  Future<List<SearchStocksCryptoModel>> getCryptoData(String parameter);

  Future<Map<String, dynamic>> getCryptoCurrency(String parameter);
}

class RemoteSearchCryptoImp extends Repository implements RemoteSearchCrypto {
  @override
  Future<Map<String, dynamic>> getCryptoCurrency(String parameter) async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '$financialInformationEndpoint/getSymbolValue?symbol=$parameter',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return result.data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<SearchStocksCryptoModel>> getCryptoData(String parameter) async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '$financialInformationEndpoint/cyptos?q=$parameter',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final List<SearchStocksCryptoModel> data = [];
        result.data['quotes'].forEach((e) {
          data.add(SearchStocksCryptoModel.fromJson(e));
        });
        return data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
