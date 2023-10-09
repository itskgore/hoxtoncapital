import 'dart:convert';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../../../../../core/config/enviroment_config.dart';
import '../../../../../core/error/failures.dart';

abstract class SignUpDataSource {
  Future<Map<String, dynamic>> updateSignUpDetails(
    Map<String, dynamic> body,
  );

  Future<Map<String, dynamic>> validateUserDetails(Map<String, dynamic> body);

  Future<LoginModel> loginWithToken({required String token});
}

class SignupSourceImp extends Repository implements SignUpDataSource {
  final SharedPreferences sharedPreferences;

  SignupSourceImp({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> updateSignUpDetails(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response =
          await Repository().dio.post('${apiBaseUrl2}register', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        locator<SharedPreferences>().setString(
            RootApplicationAccess.userEmailIDPreferences,
            body['primary_email']);
        AppAnalytics().trackEvent(
          eventName: "hoxton-register-mobile",
          parameters: {
            "email Id": body['primary_email'],
            'firstName': body["first_name"]
          },
        );
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<Map<String, dynamic>> validateUserDetails(
      Map<String, dynamic> body) async {
    String url = "${apiBaseUrl2}isUserExists";
    String url2 = '';
    if (body['email'] != '') {
      url2 = "$url?email=${body['email']}";
    } else if (body['phone'] != '') {
      url2 = "$url?contactNumber=${body['phone']}";
    }
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(url2);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        if (response.data["isExist"] ?? false) {
          if (body['email'] != '') {
            url2 = "$url?email=${body['email']}";
            response.data['existValue'] = "email";
          } else if (body['phone'] != '') {
            response.data['existValue'] = "phone";
          }
        } else {
          response.data['existValue'] = "";
        }

        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  String getEnv() {
    if (apiBaseUrl.toLowerCase().contains("qa")) {
      return "-qa";
    } else if (apiBaseUrl.toLowerCase().contains("stage")) {
      return "-stage";
    }
    return "";
  }

  @override
  Future<LoginModel> loginWithToken({required String token}) async {
    String tenant = "${appTheme.clientName}$env".toLowerCase();
    try {
      await isConnectedToInternetData();
      final response = await Repository().dio.post(
          "$identityEndpoint/sso/$tenant/login?token=$token",
          data: {"deviceFingerprint": "mobile"});
      final status = await hanldeStatusCode(response);
      // save event in firebase if fail
      if (response.statusCode != 201 && response.statusCode != 200) {
        await AppAnalytics().trackEvent(
            eventName: "mobile_login_api_failure",
            parameters: {"response": response.toString()});
      }
      if (status.status) {
        //save local response data
        await locator<SharedPreferences>().setString(
            RootApplicationAccess.loginUserPreferences,
            json.encode(response.data));
        final pseudonym = Jwt.parseJwt(response.data['accessToken']);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.passCodeMailPreferences, pseudonym['email']);

        String userEmail = locator<SharedPreferences>()
                .getString(RootApplicationAccess.userEmailIDPreferences) ??
            locator<SharedPreferences>()
                .getString(RootApplicationAccess.emailUserPreferences) ??
            '';
        // save event in firebase if success
        AppAnalytics().trackLogin(
            userId: pseudonym['pseudonym'],
            loginType: "password",
            email: userEmail);

        locator<SharedPreferences>().setBool(
            RootApplicationAccess.isMPinEnabledPreference,
            response.data['isMpinEnabled'] ?? false);
        await locator<SharedPreferences>()
            .remove(RootApplicationAccess.passcodeLoginPreferences);
        return LoginModel.fromJson(response.data);
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
