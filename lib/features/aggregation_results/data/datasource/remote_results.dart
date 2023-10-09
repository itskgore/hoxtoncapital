import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/asset_liabilities_charts_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';

abstract class RemoteAggregationResults {
  Future<AssetLiabilitiesChartModel> getAggregationResult(List<String> years);
}

class RemoteAggregationResultsImp extends Repository
    implements RemoteAggregationResults {
  @override
  Future<AssetLiabilitiesChartModel> getAggregationResult(
      List<String> years) async {
    try {
      await isConnectedToInternet();
      dio.options.headers["authorization"] = Repository().getToken();
      final result = await Repository().dio.get(
            '$insightsEndpoint/aggregationResults?years=$years',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<Map<String, dynamic>> chartData = [];
        result.data.forEach((e, v) {
          chartData.add(v);
        });
        Map<String, dynamic> d = {'data': chartData};
        final data = AssetLiabilitiesChartModel.fromJson(d);
        await locator<SharedPreferences>().setString(
            RootApplicationAccess.aggregationPreference,
            json.encode(result.data));
        return data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
