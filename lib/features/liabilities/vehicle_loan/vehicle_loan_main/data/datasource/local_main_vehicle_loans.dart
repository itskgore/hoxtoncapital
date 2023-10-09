import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/config/app_config.dart';

abstract class LocalMainVehicleLoans {
  Future<LiabilitiesEntity> getVehicleData();
}

class LocalMainVehicleLoansImp implements LocalMainVehicleLoans {
  LocalMainVehicleLoansImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<LiabilitiesModel> getVehicleData() async {
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
