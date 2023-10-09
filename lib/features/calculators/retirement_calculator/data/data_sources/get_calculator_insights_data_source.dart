import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/insights_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CalculatorInsightsDataSource {
  Future<InsightsModel?> getInsights();
}

class CalculatorInsightsDataSourceImpl extends Repository
    implements CalculatorInsightsDataSource {
  @override
  Future<InsightsModel?> getInsights() async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '$insightsEndpoint/dashboards/insights-performance-mobile/fetchData',
          data: {});
      final status = await hanldeStatusCode(response);

      if (status.status) {
        return InsightsModel.fromJson(response.data["dataSets"][0]["data"]);
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      handleThrownException(e);
    }
    return null;
  }
}
