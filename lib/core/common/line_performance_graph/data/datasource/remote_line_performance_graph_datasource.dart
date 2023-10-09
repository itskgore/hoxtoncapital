import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/app_config.dart';
import '../../../../config/repository_config.dart';
import '../../../../error/failures.dart';
import '../model/line_performance_model.dart';

abstract class RemoteLinePerformanceGraphDatasource {
  Future<LinePerformanceModel> getLinePerformance(
      {bool merge,
      List scope,
      String fromDate,
      String toDate,
      String assetType,
      String? id});
}

class RemoteLinePerformanceGraphDatasourceImp extends Repository
    implements RemoteLinePerformanceGraphDatasource {
  final SharedPreferences sharedPreferences;

  RemoteLinePerformanceGraphDatasourceImp({required this.sharedPreferences});

  @override
  Future<LinePerformanceModel> getLinePerformance(
      {bool? merge,
      List? scope,
      String? fromDate,
      String? toDate,
      String? assetType,
      String? id}) async {
    try {
      await isConnectedToInternet();
      String url =
          '$insightsEndpoint/aggregationResults?merge=$merge&scope=$scope&fromDate=$fromDate&toDate=$toDate&assetType=$assetType';
      if (id != "") {
        url = "$url&id=$id";
      }
      // log(url, name: "LineURL");
      final result = await Repository().dio.get(url);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        LinePerformanceModel data = LinePerformanceModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      log(e.toString());
      throw handleThrownException(e);
    }
  }
}
