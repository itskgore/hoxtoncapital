import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class LocalGetLiabilities {
  Future<LiabilitiesModel> getLiabilities();
}

class LocalGetLiabilitiesImp implements LocalGetLiabilities {
  LocalGetLiabilitiesImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getLiabilities() async {
    try {
      var res = sharedPreferences
          .getString(RootApplicationAccess.liabilitiesPreference);
      if (res == null) {
        // no data refresh data
        await RootApplicationAccess().storeLiabilities();
        res = sharedPreferences
            .getString(RootApplicationAccess.liabilitiesPreference);
      }
      return LiabilitiesModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }
}
