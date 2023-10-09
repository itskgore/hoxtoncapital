import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import 'enviroment_config.dart';

class Repository {
  late Dio dio;
  Repository() {
    _setup();
  }
  String getToken() {
    String res = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        locator<SharedPreferences>()
            .getString(RootApplicationAccess.passcodeLoginPreferences) ??
        "";
    if (res != "") {
      var decodedRes = LoginModel.fromJson(json.decode(res));
      return "bearer ${decodedRes.accessToken}";
    } else {
      return "";
    }
  }

  Future<bool> isConnectedToInternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      if (isTokenExpired()) {
        // refresh token API called
        await RootApplicationAccess().refreshToken();
        return true;
      } else {
        return true;
      }
    } else {
      throw const SocketException("You are disconnected from the internet.");
    }
  }

  _setup() async {
    // Token expire check
    dio = Dio(BaseOptions(
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
      baseUrl: apiBaseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: Duration(milliseconds: 100000),
      receiveTimeout: Duration(milliseconds: 300000),
    ));
    setupToken();
  }

  bool isTokenExpired() {
    String res = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        locator<SharedPreferences>()
            .getString(RootApplicationAccess.passcodeLoginPreferences) ??
        "";

    if (res != "") {
      if (json.decode(res).isNotEmpty) {
        var decodedRes = LoginModel.fromJson(json.decode(res));
        final expirationDate =
            JwtDecoder.getExpirationDate(decodedRes.accessToken);
        return DateTime.now()
            .add(const Duration(minutes: 2))
            .isAfter(expirationDate);
      }
      return false;
    } else {
      return false;
    }
  }

  void setupToken() {
    String res = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        locator<SharedPreferences>()
            .getString(RootApplicationAccess.passcodeLoginPreferences) ??
        "";

    if (res != "") {
      var decodedRes = LoginModel.fromJson(json.decode(res));
      dio.options.headers["authorization"] = "bearer ${decodedRes.accessToken}";
    }
  }
}
