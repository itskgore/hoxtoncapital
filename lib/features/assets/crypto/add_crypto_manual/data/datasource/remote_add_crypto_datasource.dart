import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/cryptp_currency_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteAddUpdateCryptoDataSource {
  Future<CryptoCurrenciesModel> addCryptoData(Map<String, dynamic> body);

  Future<CryptoCurrenciesModel> udpateCryptoData(Map<String, dynamic> body);
}

class RemoteAddUpdateCryptoDataSourceImp extends Repository
    implements RemoteAddUpdateCryptoDataSource {
  RemoteAddUpdateCryptoDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<CryptoCurrenciesModel> addCryptoData(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.post(
          '$financialInformationEndpoint/assets/cryptoCurrencies',
          data: json.encode(body));
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final cryptoModel = CryptoCurrenciesModel.fromJson(result.data);
        await RootApplicationAccess().storeAssets();
        return cryptoModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<CryptoCurrenciesModel> udpateCryptoData(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '$financialInformationEndpoint/assets/cryptoCurrencies/${body['id']}',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final cryptoModel = CryptoCurrenciesModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return cryptoModel;
      } else {
        throw status.failure!;
      }
    } on DioException catch (e) {
      throw handleThrownException(e);
    }
  }
}
