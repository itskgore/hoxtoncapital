import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/dashboard_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../model/disconnected_account_model.dart';

abstract class DashboardDataSource {
  Future<DashboardDataModel> getDashBoardData();

  Future<List<DisconnectedAccountsModel>> getDisconnectedAccounts();
}

class DashboardDataSourceImp extends Repository implements DashboardDataSource {
  @override
  Future<DashboardDataModel> getDashBoardData() async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.post(
          "$insightsEndpoint/dashboards/insights-performance-mobile/fetchData?cumulativeMonthlyCashFlow=true",
          data: {});
      final status = await hanldeStatusCode(result);
      if (status.status) {
        var data = DashboardDataModel.fromJson(result.data['dataSets'][0]);
        return data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<DisconnectedAccountsModel>> getDisconnectedAccounts() async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get(
            "$financialInformationEndpoint/fi/disconnectedLinkedAccounts",
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final List<DisconnectedAccountsModel> data = [];
        result.data.forEach((e) {
          data.add(DisconnectedAccountsModel.fromJson(e));
        });
        return data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
