import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

import '../../../../../core/config/app_config.dart';

abstract class LocalLoginDataSource {
  Future saveToken(LoginModel loginModel);

  Future getToken();

  Future saveEmailUser(LoginEmailEntity data);
}

class LocalLoginDataSourceImp implements LocalLoginDataSource {
  final SharedPreferences sharedPreferences;

  LocalLoginDataSourceImp({required this.sharedPreferences});

  @override
  Future getToken() async {
    // TODO: implement getToken
    throw UnimplementedError();
  }

  @override
  Future saveToken(LoginModel data) async {
    sharedPreferences.setString(
        RootApplicationAccess.loginUserPreferences, json.encode(data));
  }

  @override
  Future saveEmailUser(LoginEmailEntity data) async {
    sharedPreferences.setString(
        RootApplicationAccess.emailUserPreferences, json.encode(data));
  }
}
