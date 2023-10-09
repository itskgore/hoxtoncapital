import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/enviroment_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/verified_user_model.dart';

import '../../../../../core/data_models/user_account_data_model.dart';

abstract class LoginDataSource {
  Future<VerifiedUser> verifyEmail(String email);

  Future<LoginModel> login(
      String email, String password, bool isTermsAndConditionsAccepted);

  Future<bool> resetPassword(String email);

  Future<dynamic> loginWithOTP(
      String email, String password, bool isTermsAndConditionsAccepted,
      {String? passcode, bool? isOTPVerified});

  Future<LoginModel> validateOtp(String email, String password);

  Future<int> resendOTP(String email);
}

class LoginDataSourceImpl extends Repository implements LoginDataSource {
  LoginDataSourceImpl();

  String getEnv() {
    if (apiBaseUrl.toLowerCase().contains("qa")) {
      return "-qa";
    } else if (apiBaseUrl.toLowerCase().contains("stage")) {
      return "-stage";
    }
    return "";
  }

  @override
  Future<VerifiedUser> verifyEmail(String email) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .get('$identityEndpoint/auth/getUser', queryParameters: {
        "tenant": "${appTheme.clientName}${getEnv()}".toLowerCase(),
        "email": email.replaceAll(' ', '')
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return VerifiedUser.fromJson(response.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<LoginModel> login(
      String email, String password, bool isTermsAndConditionsAccepted) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.post(loginUrl, data: {
        "email": email.replaceAll(' ', ''),
        "password": password,
        "isTermsAndConditionsAccepted": isTermsAndConditionsAccepted,
        "deviceFingerprint": "mobile"
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final pseudonym = Jwt.parseJwt(response.data['accessToken']);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.userIdPreferences,
            pseudonym['pseudonym'].toString());

        String userEmail = locator<SharedPreferences>()
                .getString(RootApplicationAccess.userEmailIDPreferences) ??
            locator<SharedPreferences>()
                .getString(RootApplicationAccess.emailUserPreferences) ??
            '';
        AppAnalytics().trackLogin(
            userId: pseudonym['pseudonym'],
            loginType: "password",
            email: userEmail);

        if (locator<SharedPreferences>()
            .containsKey(RootApplicationAccess.passcodeLoginPreferences)) {
          locator<SharedPreferences>().setString(
              RootApplicationAccess.loginUserPreferences,
              locator<SharedPreferences>().getString(
                      RootApplicationAccess.passcodeLoginPreferences) ??
                  "");
        }
        return LoginModel.fromJson(response.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> resetPassword(String email) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post(forgotPasswordUrl, data: {"email": email.replaceAll(' ', '')});
      final status = await hanldeStatusCode(response);
      if (status.status) {
        // print("api fp tetst");
        return true;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  bool checkIsOTPVerified(String currentEmail) {
    return true;
    String? localUserEmail = locator<SharedPreferences>()
        .getString(RootApplicationAccess.passCodeMailPreferences);
    if (currentEmail == localUserEmail) {
      return locator<SharedPreferences>()
              .getBool(RootApplicationAccess.isOTPVerifiedPreference) ??
          false;
    } else
      return false;
  }

  @override
  Future<dynamic> loginWithOTP(
      String email, String password, bool isTermsAndConditionsAccepted,
      {String? passcode, bool? isOTPVerified}) async {
    var userEmail = email.replaceAll(' ', '');

    final Map<String, dynamic> request = {
      "email": userEmail,
      "isOTPVerified": true,
      "isTermsAndConditionsAccepted": isTermsAndConditionsAccepted,
      "deviceFingerprint": "mobile"
    };
    try {
      await isConnectedToInternetData();
      final response = await Repository().dio.post(loginUrl, data: {
        "email": userEmail,
        "password": password,
        // "isOTPVerified": isOTPVerified ?? checkIsOTPVerified(userEmail),
        "isOTPVerified": true,
        "isTermsAndConditionsAccepted": isTermsAndConditionsAccepted,
        "passCode": passcode ?? "",
        "deviceFingerprint": "mobile"
      });
      final status = await hanldeStatusCode(response);
      if (response.statusCode != 201 && response.statusCode != 200) {
        await AppAnalytics().trackEvent(
            eventName: "mobile_login_api_failure",
            parameters: {
              "request": request.toString(),
              "response": response.toString()
            });
      }
      if (status.status) {
        final userData = UserAccountDataModel.fromJson(response.data);
        await RootApplicationAccess().storeUserDetails(userData);
        final pseudonym = Jwt.parseJwt(response.data['accessToken']);
        await locator<SharedPreferences>().setString(
            RootApplicationAccess.passCodeMailPreferences, pseudonym['email']);

        AppAnalytics().trackLogin(
            userId: pseudonym['pseudonym'],
            loginType: "passcode",
            email: email);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.userIdPreferences,
            pseudonym['pseudonym'].toString());
        locator<SharedPreferences>().setBool(
            RootApplicationAccess.isMPinEnabledPreference,
            response.data['isMpinEnabled'] ?? false);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.loginUserPreferences,
            json.encode(response.data));
        log("${locator<SharedPreferences>().getString(RootApplicationAccess.loginUserPreferences)}",
            name: RootApplicationAccess.loginUserPreferences);
        locator<SharedPreferences>()
            .remove(RootApplicationAccess.passcodeLoginPreferences);
        return response.data;
        // } else {
        //   if (locator<SharedPreferences>()
        //       .containsKey(RootApplicationAccess.passcodeLogin)) {
        //     locator<SharedPreferences>()
        //         .setString(RootApplicationAccess.loginUser, json.decode(response.data));
        //   }
        //   log("${DateTime.now().toIso8601String()} Login END");
        //   return response.data;
        // }
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      AppAnalytics()
          .trackEvent(eventName: "mobile_login_api_failure", parameters: {
        "email": email,
        "error": e.toString(),
        "errorMSG": handleThrownException(e).toString(),
        "request": {
          "email": userEmail,
          "password": password,
          // "isOTPVerified": isOTPVerified ?? checkIsOTPVerified(userEmail),
          "isOTPVerified": true,
          "isTermsAndConditionsAccepted": isTermsAndConditionsAccepted,
          "passCode": passcode ?? "",
          "deviceFingerprint": "mobile"
        }
      });
      throw handleThrownException(e);
    }
  }

  @override
  Future<LoginModel> validateOtp(String email, String password) async {
    // TODO: implement validateOtp
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(validateOtpUrl, data: {
        "email": email.replaceAll(' ', ''),
        "code": password,
        "deviceFingerprint": "mobile"
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final pseudonym = Jwt.parseJwt(response.data['accessToken']);

        AppAnalytics().trackLogin(
            userId: pseudonym['pseudonym'],
            loginType: "password",
            email: email);

        locator<SharedPreferences>().setString(
            RootApplicationAccess.userIdPreferences,
            pseudonym['pseudonym'].toString());
        locator<SharedPreferences>().setBool(
            RootApplicationAccess.isMPinEnabledPreference,
            response.data['isMpinEnabled'] ?? false);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.loginUserPreferences,
            json.encode(response.data));
        return LoginModel.fromJson(response.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<int> resendOTP(String email) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.post(resendOtpUrl, data: {
        "email": email.replaceAll(' ', ''),
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return 200;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
