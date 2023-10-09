import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalVehiclesDataSource {
  Future<AssetsModel> getVehicles();
// Future getToken();
}

class LocalVehiclesDataSourceImp implements LocalVehiclesDataSource {
  final SharedPreferences sharedPreferences;

  LocalVehiclesDataSourceImp({required this.sharedPreferences});

  @override
  Future<AssetsModel> getVehicles() async {
    try {
      final res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      // print(res);
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }
}
