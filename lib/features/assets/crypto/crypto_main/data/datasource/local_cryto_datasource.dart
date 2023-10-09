import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';
import '../models/crypto_performance_model.dart';

abstract class LocalCryptoCurrenciesDataSource {
  Future<AssetsModel> getCryptoData();

  Future<CryptoPerformanceModel> getCryptoPerformance({
    bool merge,
    List scope,
    String fromDate,
    String toDate,
    String? assetType,
    String? id,
  });
}

class LocalCryptoCurrenciesDataSourceImp extends Repository
    implements LocalCryptoCurrenciesDataSource {
  LocalCryptoCurrenciesDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<AssetsModel> getCryptoData() async {
    try {
      final res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      // print(res);
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }

  @override
  Future<CryptoPerformanceModel> getCryptoPerformance(
      {bool? merge,
      List? scope,
      String? fromDate,
      String? toDate,
      String? assetType,
      String? id}) async {
    {
      try {
        String URL;
        if (id != null) {
          URL =
              '${insightsEndpoint}aggregationResults?merge=$merge&scope=$scope&fromDate=$fromDate&toDate=$toDate&id=$id';
        } else {
          URL =
              '${insightsEndpoint}aggregationResults?merge=$merge&scope=$scope&fromDate=$fromDate&toDate=$toDate&assetType=$assetType';
        }
        final result = await Repository().dio.get(URL);
        final status = await hanldeStatusCode(result);
        if (status.status) {
          CryptoPerformanceModel data =
              CryptoPerformanceModel.fromJson(result.data);
          return data;
        } else {
          throw status.failure ?? ServerFailure();
        }
      } catch (e) {
        throw handleThrownException(e);
      }
    }
  }
}
