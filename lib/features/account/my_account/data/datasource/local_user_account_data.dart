import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/data_models/user_account_data_model.dart';
import 'package:wedge/dependency_injection.dart';

abstract class LocalUserAccountData {
  Future<UserAccountDataModel> getUserLocal();
}

class LocalUserAccountDataImp implements LocalUserAccountData {
  @override
  Future<UserAccountDataModel> getUserLocal() async {
    final result = locator<SharedPreferences>()
        .getString(RootApplicationAccess.userAccountPreference);
    return UserAccountDataModel.fromJson(json.decode(result!));
  }
}
