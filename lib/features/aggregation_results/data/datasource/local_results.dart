import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/asset_liabilities_charts_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';

abstract class LocalAggregationResults {
  Future<AssetLiabilitiesChartModel> getAggregationResult(List<String> years);
}

class LocalAggregationResultsImp extends LocalAggregationResults {
  @override
  Future<AssetLiabilitiesChartModel> getAggregationResult(
      List<String> years) async {
    try {
      String res = locator<SharedPreferences>()
              .getString(RootApplicationAccess.aggregationPreference) ??
          "";
      return AssetLiabilitiesChartModel.fromJson(json.decode(res));
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
