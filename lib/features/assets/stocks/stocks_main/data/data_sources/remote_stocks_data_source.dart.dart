import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/stocks_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../models/stocks_performance_model.dart';

abstract class RemoteStocksSource {
  Future<StocksBondsModel> deleteStock(String id);

  Future<StocksPerformanceModel> getStocksPerformance({
    bool merge,
    List scope,
    String fromDate,
    String toDate,
    String? assetType,
    String? id,
  });
}

class RemoteStocksSourceImpl extends Repository implements RemoteStocksSource {
  final SharedPreferences sharedPreferences;

  RemoteStocksSourceImpl({required this.sharedPreferences});

  @override
  Future<StocksBondsModel> deleteStock(String id) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/stocksBonds/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final stocksBondsModel = StocksBondsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return stocksBondsModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<StocksPerformanceModel> getStocksPerformance(
      {bool? merge,
      List? scope,
      String? fromDate,
      String? toDate,
      String? assetType,
      String? id}) async {
    {
      try {
        String URL =
            "${insightsEndpoint}aggregationResults?merge=$merge&scope=$scope&fromDate=$fromDate&toDate=$toDate";
        if (id != null) {
          URL = '$URL&id=$id';
        } else {
          URL = '$URL&assetType=$assetType';
        }
        await isConnectedToInternet();
        final result = await Repository().dio.get(URL);
        final status = await hanldeStatusCode(result);
        if (status.status) {
          StocksPerformanceModel data =
              StocksPerformanceModel.fromJson(result.data);
          log("data: $data");
          return data;
        } else {
          throw status.failure ?? ServerFailure();
        }
      } catch (e) {
        log("exception:", error: e);
        throw handleThrownException(e);
      }
    }
  }
}
