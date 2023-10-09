import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/investments_holdings_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../model/Investment_performance_model.dart';

abstract class RemoteYourInvestment {
  Future<List<InvestmentHoldingsModel>> getHoldings(String id, String source);

  Future<InvestmentPerformanceModel> getInvestmentPerformance(
      bool merge, List scope, String fromDate, String toDate, String id);
}

class RemoteYourInvestmentImp extends Repository
    implements RemoteYourInvestment {
  @override
  Future<List<InvestmentHoldingsModel>> getHoldings(
      String id, String source) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get(
          '$financialInformationEndpoint/holdings?aggregatorAccountId=$id&source=$source');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        List<InvestmentHoldingsModel> data = [];
        result.data.forEach((e) {
          data.add(InvestmentHoldingsModel.fromJson(e));
        });
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<InvestmentPerformanceModel> getInvestmentPerformance(
      bool merge, List scope, String fromDate, String toDate, String id) async {
    try {
      await isConnectedToInternet();

      String URL =
          '$insightsEndpoint/aggregationResults?merge=$merge&scope=$scope&fromDate=$fromDate&toDate=$toDate&id=$id';

      final result = await Repository().dio.get(URL);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        InvestmentPerformanceModel data =
            InvestmentPerformanceModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
