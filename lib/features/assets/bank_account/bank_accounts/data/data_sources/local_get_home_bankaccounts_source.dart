import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class LocalHomeBankAccountsDataSource {
  Future<AssetsModel> getBankAccounts();
}

class LocalHomeBankAccountsDataSourceImp
    implements LocalHomeBankAccountsDataSource {
  final SharedPreferences sharedPreferences;

  LocalHomeBankAccountsDataSourceImp({required this.sharedPreferences});

  @override
  Future<AssetsModel> getBankAccounts() async {
    try {
      await RootApplicationAccess().storeAssets();
      final res =
          sharedPreferences.getString(RootApplicationAccess.assetsPreference);
      return AssetsModel.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }
}
