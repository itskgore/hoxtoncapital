import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/stocks_crypto_search_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteSearchStocks {
  Future<List<SearchStocksCryptoModel>> getStocksData(String parameter);

  Future<Map<String, dynamic>> getStocksCurrency(String parameter);
}

class RemoteSearchStocksImp extends Repository implements RemoteSearchStocks {
  @override
  Future<Map<String, dynamic>> getStocksCurrency(String parameter) async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '${financialInformationEndpoint}/getSymbolValue?symbol=$parameter',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        // {
        //   "currency": "INR",
        //   "price": 875.95
        // }
        return result.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<SearchStocksCryptoModel>> getStocksData(String parameter) async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '${financialInformationEndpoint}/stocks?q=$parameter',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final List<SearchStocksCryptoModel> data = [];
        result.data['quotes'].forEach((e) {
          data.add(SearchStocksCryptoModel.fromJson(e));
        });
        return data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
