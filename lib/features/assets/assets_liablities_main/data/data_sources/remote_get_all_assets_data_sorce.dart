import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';

import '../Models/assets_liabilities_model.dart';

abstract class MainAssetsLiabilitiesdataSource {
  Future<AssetsModel> getMainAssets();

  Future<LiabilitiesModel> getMainLiabilities();

  Future<AssetsLiabilitiesModel> getMainAssetsLiabilities();
}

class MainAssetsLiabilitiesdataSourceImpl extends Repository
    implements MainAssetsLiabilitiesdataSource {
  MainAssetsLiabilitiesdataSourceImpl();

  @override
  Future<AssetsModel> getMainAssets() async {
    try {
      await isConnectedToInternet();
      final response =
          await Repository().dio.get('$financialInformationEndpoint/assets');
      log('Assets API called in remote_get_all_assets_data_sorce.dart');

      final status = await hanldeStatusCode(response);
      if (status.status) {
        return AssetsModel.fromJson(response.data);
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<LiabilitiesModel> getMainLiabilities() async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .get('$financialInformationEndpoint/liabilities');
      log('Liabilities API called in remote_get_all_assets_data_sorce.dart');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return LiabilitiesModel.fromJson(response.data);
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<AssetsLiabilitiesModel> getMainAssetsLiabilities() async {
    try {
      await isConnectedToInternet();
      final response =
          await Repository().dio.get('$financialInformationEndpoint/fi');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        locator<SharedPreferences>().setString(
            RootApplicationAccess.liabilitiesPreference,
            json.encode(response.data['liabilities']));
        locator<SharedPreferences>().setString(
            RootApplicationAccess.liabilitiesPreference,
            json.encode(response.data['liabilities']));
        locator<SharedPreferences>().setString(
            RootApplicationAccess.assetsPreference,
            json.encode(response.data['assets']));
        return AssetsLiabilitiesModel.fromJson(response.data);
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
