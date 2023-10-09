import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/verified_user_model.dart';

abstract class MainPensionInvestmentDataSource {
  Future<AssetsModel> getHoxtonDataSummery();

  Future<VerifiedUser> getUserDetails();

  Future<dynamic> getInsights();
}

class MainPensionInvestmentDataSourceImpl extends Repository
    implements MainPensionInvestmentDataSource {
  // HoxtonUserDataSourceImpl();
  final SharedPreferences sharedPreferences;

  MainPensionInvestmentDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AssetsModel> getHoxtonDataSummery() async {
    try {
      log(
        "dio.options.headers : ${dio.options.headers}",
        name: "getHoxtonDataSummery",
        time: DateTime.now(),
      );
      await isConnectedToInternet();
      final response =
          await Repository().dio.get('/$financialInformationEndpoint/assets');
      log('Assets API called in hoxton_userdata_source.dart');

      final status = await hanldeStatusCode(response);
      if (status.status) {
        return AssetsModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<VerifiedUser> getUserDetails() async {
    try {
      final res = sharedPreferences
          .getString(RootApplicationAccess.emailUserPreferences);
      return VerifiedUser.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }

  @override
  Future getInsights() async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
            '/$insightsEndpoint/aggregationResults?merge=true&scope=[fi]&fromDate=${DateTime.now().subtract(const Duration(days: 30))}&toDate=${DateTime.now()}&assetType=investment',
          );
      response.data['merge']['fi']['performanceSummary'].forEach((e) {});
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data['merge']['fi']['performanceSummary'];
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
