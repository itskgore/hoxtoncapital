import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalStocksDataSource {
  Future<AssetsModel> getStocks();

// Future getToken();
}

class LocalStocksDataSourceImp implements LocalStocksDataSource {
  final SharedPreferences sharedPreferences;

  LocalStocksDataSourceImp({required this.sharedPreferences});

  @override
  Future<AssetsModel> getStocks() async {
    try {
      final res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }
}
