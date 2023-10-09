import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalPropertiesDataSource {
  Future<AssetsModel> getProperties();
}

class LocalPropertiesDataSourceImp implements LocalPropertiesDataSource {
  final SharedPreferences sharedPreferences;

  LocalPropertiesDataSourceImp({required this.sharedPreferences});

  @override
  Future<AssetsModel> getProperties() async {
    try {
      final res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }
}
