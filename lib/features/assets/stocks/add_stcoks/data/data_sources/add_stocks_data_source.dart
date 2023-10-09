import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/stocks_model.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddStocksDataSource {
  Future<StocksBondsModel> addStocks(
      String name, double quantity, ValueEntity value, String symbol);

  Future<StocksBondsModel> updateStocks(String name, double quantity,
      ValueEntity value, String id, String symbol);
}

class AddStocksDataSourceImpl extends Repository
    implements AddStocksDataSource {
  // final _sharedPreferences = SharedPreferences.getInstance();
  final SharedPreferences sharedPreferences;

  AddStocksDataSourceImpl({required this.sharedPreferences});

  @override
  Future<StocksBondsModel> addStocks(
      String name, double quantity, ValueEntity value, String symbol) async {
    try {
      await isConnectedToInternet();
      final response = await dio
          .post('$financialInformationEndpoint/assets/stocksBonds', data: {
        "name": name,
        "quantity": quantity,
        "symbol": symbol,
        "country": "UAE",
        "type": "",
        "value": {
          "amount": double.parse(value.amount.toString()),
          "currency": value.currency
        }
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = StocksBondsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return assetModel;
      } else {
        // print("failded");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<StocksBondsModel> updateStocks(String name, double quantity,
      ValueEntity value, String id, String symbol) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .put('$financialInformationEndpoint/assets/stocksBonds/$id', data: {
        "id": id,
        "name": name,
        "quantity": quantity,
        "symbol": symbol,
        "country": "UAE",
        "type": "",
        "value": {
          "amount": double.parse(value.amount.toString()),
          "currency": value.currency
        }
        //{"amount": 22.00, "currency": "AED"}
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = StocksBondsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return assetModel;
      } else {
        throw status.failure!;
      }
    } on DioException catch (e) {
      throw handleThrownException(e);
    }
  }
}
