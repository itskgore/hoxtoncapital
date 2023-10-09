import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalMainMortage {
  Future<LiabilitiesModel> getMortageData();
}

class LocalMainMortageImp implements LocalMainMortage {
  LocalMainMortageImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getMortageData() async {
    try {
      final res = sharedPreferences
          .getString(RootApplicationAccess.liabilitiesPreference);
      // print(res);
      return LiabilitiesModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }
}
