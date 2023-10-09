import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalOtherLiabilitiesDatasource {
  Future<LiabilitiesModel> getOtherLiabilitiesData();
}

class LocalOtherLiabilitiesDatasourceImp
    implements LocalOtherLiabilitiesDatasource {
  LocalOtherLiabilitiesDatasourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getOtherLiabilitiesData() async {
    try {
      final res = sharedPreferences
          .getString(RootApplicationAccess.liabilitiesPreference);
      return LiabilitiesModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }
}
