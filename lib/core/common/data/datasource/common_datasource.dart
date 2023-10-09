import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/contants/enums.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CommonDataSource {
  Future<Map<String, dynamic>> refreshAgreegatorAccount(
      Map<String, dynamic> body);
  Future<List<Map<String, dynamic>>> excelDownload(Map<String, dynamic> body);
  Future<dynamic> getNotificationAndBanner();
  Future<Map<String, dynamic>> updateNotificationAndBanner(
      List<Map<String, dynamic>> data);
}

class CommonDataSourceImp extends Repository implements CommonDataSource {
  final SharedPreferences sharedPreferences;

  CommonDataSourceImp({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> refreshAgreegatorAccount(
      Map<String, dynamic> body) async {
    try {
      bool isSaltedge = body['provider'].toString().toLowerCase() ==
          AggregatorProvider.Saltedge.name.toLowerCase();
      bool isYodlee = body['provider'].toString().toLowerCase() ==
          AggregatorProvider.Yodlee.name.toLowerCase();

      late String refreshUrl;
      if (isSaltedge) {
        refreshUrl =
            '$financialInformationEndpoint/reconnectAccount/${body['provider']}';
      } else if (isYodlee) {
        refreshUrl = '$financialInformationEndpoint/tokens/${body['provider']}';
      }

      await isConnectedToInternet();
      final response =
          await Repository().dio.post(refreshUrl, data: body['data']);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> excelDownload(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
            '${insightsEndpoint}reports/transactions/export?aggregatorAccountId=${body['aggregatorAccountId']}&month=${body['month']}&fileFormat=json',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        List<Map<String, dynamic>> mapList = [];
        response.data.forEach((e) {
          mapList.add(e);
        });
        return mapList;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future getNotificationAndBanner() async {
    try {
      await isConnectedToInternet();
      String url = "$notificationEndPoint/messages";
      final Response response = await Repository().dio.get(url);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateNotificationAndBanner(
      List<Map<String, dynamic>> data) async {
    try {
      await isConnectedToInternet();
      String url = "$notificationEndPoint/messages/changeStatus";
      final Response response = await Repository().dio.put(url, data: data);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
