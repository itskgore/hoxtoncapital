import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class LocalAllAssetsDataSource {
  Future<AssetsModel> getAssets();
}

class LocalAllAssetsDataSourceSourceImp implements LocalAllAssetsDataSource {
  final SharedPreferences sharedPreferences;

  LocalAllAssetsDataSourceSourceImp({required this.sharedPreferences});

  @override
  Future<AssetsModel> getAssets() async {
    try {
      var res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      if (res == null) {
        // no data refresh data
        await RootApplicationAccess().storeAssets();
        res =
            sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      }
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }
}
