import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalPersonalLoanDataSource {
  Future<LiabilitiesModel> getPersonalLoan();
}

class LocalPersonalLoanDataSourceImp extends Repository
    implements LocalPersonalLoanDataSource {
  LocalPersonalLoanDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getPersonalLoan() async {
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
