import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/enviroment_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/user_account_data_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

abstract class RemoteTermConditionDataSource {
  Future<bool> acceptTermCondition();
}

class RemoteTermConditionDataSourceImp extends Repository
    with RemoteTermConditionDataSource {
  @override
  Future<bool> acceptTermCondition() async {
    try {
      final userdata = locator<SharedPreferences>()
              .getString(RootApplicationAccess.loginUserPreferences) ??
          "";
      final data = LoginModel.fromJson(json.decode(userdata));
      final userMail = locator<SharedPreferences>()
              .getString(RootApplicationAccess.userAccountPreference) ??
          "";
      final email = UserAccountDataModel.fromJson(json.decode(userMail));
      final userEmail = email.email != ""
          ? email.email
          : locator<SharedPreferences>()
              .getString(RootApplicationAccess.passCodeMailPreferences);
      final response = await Repository().dio.post(
          "${authBaseUrl}acceptTermsAndConditions",
          data: json
              .encode({"accessToken": data.accessToken, "email": userEmail}));
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return status.status;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
