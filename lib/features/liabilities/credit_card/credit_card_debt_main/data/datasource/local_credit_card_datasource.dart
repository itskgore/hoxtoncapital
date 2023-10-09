import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalCreditCardDatasource {
  Future<LiabilitiesModel> getCreditCardData();
}

class LocalCreditCardDatasourceImp implements LocalCreditCardDatasource {
  LocalCreditCardDatasourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getCreditCardData() async {
    try {
      final res = sharedPreferences
          .getString(RootApplicationAccess.liabilitiesPreference);
      return LiabilitiesModel.fromJson(json.decode(res!));
    } catch (e) {
      throw CacheFailure();
    }
  }
}
