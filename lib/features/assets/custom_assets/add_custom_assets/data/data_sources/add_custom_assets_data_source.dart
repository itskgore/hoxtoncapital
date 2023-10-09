import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/other_assets_model.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

abstract class AddCustomAssetsDataSource {
  Future<OtherAssetsModel> addCustomAssets(
      String name, String country, String type, ValueEntity value);

  Future<OtherAssetsModel> updateCustomAssets(String name, String country,
      String currency, ValueEntity currentAmount, String id);
}

class AddCustomAssetsDataSourceImpl extends Repository
    implements AddCustomAssetsDataSource {
  final SharedPreferences sharedPreferences;

  AddCustomAssetsDataSourceImpl({required this.sharedPreferences});

  @override
  Future<OtherAssetsModel> addCustomAssets(
      String name, String country, String type, ValueEntity value) async {
    try {
      final userData = sharedPreferences
          .getString(RootApplicationAccess.loginUserPreferences);
      final data = LoginModel.fromJson(json.decode(userData!));
      await isConnectedToInternet();
      dio.options.headers["authorization"] = "bearer ${data.accessToken}";
      final response = await Repository()
          .dio
          .post('$financialInformationEndpoint/assets/otherAssets', data: {
        "name": name,
        "country": country,
        "type": type,
        "value": {
          "amount": double.parse(value.amount.toString()),
          "currency": value.currency
        }
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = OtherAssetsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return assetModel;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<OtherAssetsModel> updateCustomAssets(String name, String country,
      String type, ValueEntity value, String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository()
          .dio
          .put('$financialInformationEndpoint/assets/otherAssets/$id', data: {
        "name": name,
        "country": country,
        "type": type,
        "value": {
          "amount": double.parse(value.amount.toString()),
          "currency": value.currency
        }
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final otherAssetsModel = OtherAssetsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return otherAssetsModel;
      } else {
        // print("failed");
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
