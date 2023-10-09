import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../dependency_injection.dart';
import '../Models/assets_liabilities_model.dart';

abstract class MainLocalAssetsLiabilitiesDataSource {
  Future saveAssets(AssetsModel loginModel);

  Future saveLiabilities(LiabilitiesModel loginModel);

  Future saveAssetsLiabilities(AssetsLiabilitiesModel loginModel);

  Future<AssetsLiabilitiesModel> getMainAssetsLiabilities();
}

class MainLocalAssetsLiabilitiesDataSourceImp
    implements MainLocalAssetsLiabilitiesDataSource {
  final SharedPreferences sharedPreferences;

  MainLocalAssetsLiabilitiesDataSourceImp({required this.sharedPreferences});

  @override
  Future saveAssets(AssetsModel assetsModel) async {
    await sharedPreferences.setString(
        RootApplicationAccess.assetsPreference, json.encode(assetsModel));
  }

  @override
  Future saveLiabilities(LiabilitiesModel liabilitiesModel) async {
    sharedPreferences.setString(RootApplicationAccess.liabilitiesPreference,
        json.encode(liabilitiesModel));
  }

  @override
  Future saveAssetsLiabilities(
      AssetsLiabilitiesModel assetsLiabilitiesModel) async {
    sharedPreferences.setString(RootApplicationAccess.liabilitiesPreference,
        json.encode(assetsLiabilitiesModel.liabilities));
    sharedPreferences.setString(RootApplicationAccess.assetsPreference,
        json.encode(assetsLiabilitiesModel.assets));
  }

  @override
  Future<AssetsLiabilitiesModel> getMainAssetsLiabilities() async {
    await isConnectedToInternet();
    final assetsJson = jsonDecode(locator<SharedPreferences>()
            .getString(RootApplicationAccess.assetsPreference) ??
        '');

    final liabilitiesJson = jsonDecode(locator<SharedPreferences>()
        .getString(RootApplicationAccess.liabilitiesPreference)!);

    final data = {
      "assets": assetsJson,
      "liabilities": liabilitiesJson,
      "updatedAt": ''
    };
    return AssetsLiabilitiesModel.fromJson(data);
  }

  isConnectedToInternet() {}
}
