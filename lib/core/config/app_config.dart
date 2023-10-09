import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_icons.dart';
import 'package:wedge/core/config/enviroment_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/asset_liabilities_charts_model.dart';
import 'package:wedge/core/data_models/assets_model.dart';
import 'package:wedge/core/data_models/insights_model.dart';
import 'package:wedge/core/data_models/liabilities_model.dart';
import 'package:wedge/core/data_models/user_account_data_model.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/pages/hoxton_login_page.dart';
import 'package:wedge/features/auth/hoxton_login/presentation/pages/hoxton_login_page_2.dart';

import '../data_models/theme_model.dart';

// ============================= API End Points ===========================

const financialInformationEndpoint = "/financial-information/v1";
const identityEndpoint = "/identity/v1";
const userPreferenceEndpoint = "/user-preference/v1";
const insightsEndpoint = "/insights/v1/";
const documentVaultEndPoint = "/documents/v1/";
const userServicesEndPoint = "/plugin/v1/";
const userPlatformEndPoint = "/platform/v1";
const notificationEndPoint = "/notification/v1";

// ============================= Theme getters ===========================

AppTheme get appTheme => locator<AppTheme>();

AppIcons get appIcons => locator<AppIcons>();

AppFonts? get appThemeFonts => locator<AppTheme>().fonts;

String? get appThemeHeadlineFont => locator<AppTheme>().fonts!.headline!.font;

String? get appThemeGenericFont => locator<AppTheme>().fonts!.genericFont;

String? get appThemeSubtitleFont => locator<AppTheme>().fonts!.subtitle!.font;

Sizes? get appThemeHeadlineSizes => locator<AppTheme>().fonts!.headline!.sizes;

Sizes? get appThemeSubtitleSizes => locator<AppTheme>().fonts!.subtitle!.sizes;

bool get appThemeHeadlineIsBold =>
    locator<AppTheme>().fonts!.headline!.isBold ?? false;

AppColors? get appThemeColors => locator<AppTheme>().colors;

AppImage? get appThemeImages => locator<AppTheme>().appImage;

// ============================= Theme getters ===========================

getCurrency() {
  final result = locator<SharedPreferences>()
      .getString(RootApplicationAccess.userPreferences);
  if (result != null) {
    final data = UserPreferencesModel.fromJson(json.decode(result));
    return data.preference.currency;
  }
  return "";
}

class RootApplicationAccess extends Repository {
  static AssetsEntity? assetsEntity;
  static LiabilitiesEntity? liabilitiesEntity;
  static UserAccountDataEntity? userAccountDataEntity;

  // store Assets Local
  Future<void> storeAssets() async {
    try {
      await isConnectedToInternet();
      final response =
          await Repository().dio.get('$financialInformationEndpoint/assets');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final AssetsModel assetApiModel = AssetsModel.fromJson(response.data);
        log("Assets API called in app_config--------------------Assets Added--------------------",
            name: "${DateTime.now()}");
        assetsEntity = assetApiModel;
        locator<SharedPreferences>().setString(
            RootApplicationAccess.assetsPreference, json.encode(assetApiModel));
      } else {
        if (status.failure is TokenExpired) {
          storeAssets();
        } else {
          throw status.failure!;
        }
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  //store Liabilities Local
  Future<void> storeLiabilities() async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .get('$financialInformationEndpoint/liabilities');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        // // log(response.data);
        final LiabilitiesModel liabilitiesApiModel =
            LiabilitiesModel.fromJson(response.data);
        log("Liability API called in app_config---------------------- Liabilities Added ----------------------",
            name: "${DateTime.now()}");
        liabilitiesEntity = liabilitiesApiModel;
        locator<SharedPreferences>().setString(
            RootApplicationAccess.liabilitiesPreference,
            json.encode(liabilitiesApiModel));
      } else {
        if (status.failure is TokenExpired) {
          storeLiabilities();
        } else {
          throw status.failure!;
        }
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  //Get Assets & Liabilities from fi
  Future<void> getAssetsLiabilities() async {
    try {
      await isConnectedToInternet();
      final response =
          await Repository().dio.get('$financialInformationEndpoint/fi');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        // // log(response.data);
        final LiabilitiesModel liabilitiesApiModel =
            LiabilitiesModel.fromJson(response.data['liabilities']);
        final AssetsModel assetApiModel =
            AssetsModel.fromJson(response.data['assets']);
        log("============== YOOOOOO Assets & Liabilities Added ====================");
        liabilitiesEntity = liabilitiesApiModel;
        locator<SharedPreferences>().setString(
            RootApplicationAccess.liabilitiesPreference,
            json.encode(liabilitiesApiModel));
        locator<SharedPreferences>().setString(
            RootApplicationAccess.assetsPreference, json.encode(assetApiModel));
      } else {
        if (status.failure is TokenExpired) {
          getAssetsLiabilities();
        } else {
          throw status.failure!;
        }
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  Future<AssetLiabilitiesChartModel> getAggregationResult(
      List<String> years) async {
    try {
      await isConnectedToInternet();

      dio.options.headers["authorization"] = Repository().getToken();
      final result = await Repository().dio.get(
            '$insightsEndpoint/aggregationResults?years=$years',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        // log(Repository().getToken());
        List<Map<String, dynamic>> chartData = [];
        result.data.forEach((e, v) {
          chartData.add(v);
        });
        Map<String, dynamic> d = {'data': chartData};
        final data = AssetLiabilitiesChartModel.fromJson(d);
        await locator<SharedPreferences>().setString(
            RootApplicationAccess.aggregationPreference, json.encode(data));
        return data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  Future<InsightsModel?> getInsights() async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.get(
          '$insightsEndpoint/dashboards/insights-performance-mobile/fetchData');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return InsightsModel.fromJson(response.data);
      } else {
        if (status.failure is TokenExpired) {
          getInsights();
        } else {
          throw status.failure!;
        }
      }
    } catch (e) {
      return handleThrownException(e);
    }
    return null;
  }

  navigateToLogin(BuildContext context,
      {bool? forMPin,
      String? userEmail,
      NavigatorType? navigatorType,
      bool? createNew,
      bool? fromLoginViaEmailButton}) async {
    bool showBioMetric = false;
    bool deviceBioEnabled = await BioMetricsAuth().checkIfDeviceHasBiometrics();
    if (deviceBioEnabled) {
      showBioMetric = locator<SharedPreferences>().getBool(
              RootApplicationAccess.isUserBioMetricIsEnabledPreference) ??
          false;
    }
    if (appTheme.singleLoginFlow ?? false) {
      // Wedge  Navigation
      cupertinoNavigator(
          context: navigatorKey.currentState!.context,
          screenName: const WedgeLoginPage(),
          type: navigatorType ?? NavigatorType.PUSHREPLACE);
    } else {
      // Third Party Navigation
      cupertinoNavigator(
          context: navigatorKey.currentState!.context,
          screenName: OtherLoginPage(
            shouldShowBioMetrics: showBioMetric,
            fromLoginViaEmailButton: fromLoginViaEmailButton,
            forMpin: forMPin,
            createNew: createNew,
            userEmail: userEmail,
          ),
          type: navigatorType ?? NavigatorType.PUSHREPLACE);
    }
  }

  logoutAndClearData({bool? isFromHome}) async {
    try {
      locator<SharedPreferences>()
          .setBool(RootApplicationAccess.isSkippedPreference, false);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.loginUserPreferences);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.liabilitiesPreference);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.emailUserPreferences);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.userAccountPreference);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.assetsPreference);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.userPreferences);
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.countryOfResident);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove("key");
      await preferences.remove(RootApplicationAccess.liabilitiesPreference);
      await preferences.remove(RootApplicationAccess.emailUserPreferences);
      await preferences.remove(RootApplicationAccess.userAccountPreference);
      await preferences.remove(RootApplicationAccess.assetsPreference);
      await preferences.remove(RootApplicationAccess.userPreferences);
      await preferences.remove(privacyModePreferences);
      userAccountDataEntity = null;
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
    } catch (e) {
      log(e.toString());
    }
  }

  bool checkUserInitialized() {
    try {
      if (userAccountDataEntity != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> storeUserDetails(
      UserAccountDataModel? userAccountDataModel) async {
    if (userAccountDataModel != null) {
      userAccountDataEntity = userAccountDataModel;
      locator<SharedPreferences>().setString(
          RootApplicationAccess.userAccountPreference,
          json.encode(userAccountDataModel));
      locator<SharedPreferences>().setString(
          RootApplicationAccess.passCodeMailPreferences,
          userAccountDataEntity?.email ?? "");
    } else {
      // if send null will get new Data and store
      await isConnectedToInternet();
      final result = await Repository().dio.get(
            '$identityEndpoint/auth/users/me',
          );
      log("============== YOOOOOO USER DETAILS FETCH ====================");
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = UserAccountDataModel.fromJson(result.data);
        userAccountDataEntity = userData;
        locator<SharedPreferences>().setString(
            RootApplicationAccess.userAccountPreference, json.encode(userData));
        locator<SharedPreferences>().setString(
            RootApplicationAccess.passCodeMailPreferences, userData.email);
      } else {
        throw status.failure!;
      }
    }
  }

  // refresh Access Token
  Future<bool> refreshToken() async {
    try {
      String res = locator<SharedPreferences>()
              .getString(RootApplicationAccess.loginUserPreferences) ??
          locator<SharedPreferences>()
              .getString(RootApplicationAccess.passcodeLoginPreferences) ??
          "";
      log(
          name: RootApplicationAccess.loginUserPreferences,
          "${locator<SharedPreferences>().getString(RootApplicationAccess.loginUserPreferences)}");
      log(
          name: "passcodeLogin",
          locator<SharedPreferences>()
              .getString(RootApplicationAccess.passcodeLoginPreferences)
              .toString());

      var decodedRes = LoginModel.fromJson(json.decode(res));
      Dio dio = Dio(BaseOptions(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
        baseUrl: apiBaseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(milliseconds: 100000),
        receiveTimeout: const Duration(milliseconds: 300000),
      ));
      final response = await dio
          .post('$apiBaseUrl$identityEndpoint/auth/refreshAccessToken', data: {
        "refreshToken": decodedRes.refreshToken,
        "accessToken": decodedRes.accessToken,
        "deviceFingerprint": "mobile"
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        log("============== YOOOOOO Refresh Token ====================");
        final newData = LoginModel(
            enableOTP: response.data['enableOTP'] ?? false,
            isProfileCompleted: response.data['isProfileCompleted'] ?? true,
            isMpineEnabled:
                locator<SharedPreferences>().getBool(isMPinEnabledPreference) ??
                    false,
            accessToken: response.data['accessToken'],
            refreshToken: response.data['refreshToken'],
            isOnboardingCompleted: decodedRes.isOnboardingCompleted,
            isTermsAndConditionsAccepted:
                decodedRes.isTermsAndConditionsAccepted,
            lastLogin: decodedRes.lastLogin);

        await locator<SharedPreferences>().setString(
            RootApplicationAccess.loginUserPreferences, json.encode(newData));
        await locator<SharedPreferences>().setString(
            RootApplicationAccess.passcodeLoginPreferences,
            json.encode(newData));

        // replace the Login data accesstoken and refreshToken
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // refresh FCM Token
  Future<bool> refreshFCMToken() async {
    try {
      await isConnectedToInternet();
      final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      final token = await firebaseMessaging.getToken();
      final response = await Repository()
          .dio
          .post('$identityEndpoint/pushNotifications', data: {
        "provider": "firebase",
        "platform": "mobile",
        "token": "$token"
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        log("============== YOOOOOO FCM Token ====================");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ======================== SharedPreferences Keys ===========================

  // SharedPreferences Keys Strings
  static const String liabilitiesPreference = "liabilitiesPreference";
  static const String assetsPreference = "assetsPreference";
  static const String aggregationPreference = "aggregationPreference";
  static const String userAccountPreference = "userAccount";
  static const String userPreferences = "userPreferences";
  static const String privacyModePreferences = "privacyMode";
  static const String appPasscodePreferences = "appPasscode";
  static const String authBioSelectedPreferences = "authBioSelected";
  static const String passCodeMailPreferences = "passCodeMail";
  static const String passcodeLoginPreferences = "passcodeLogin";
  static const String emailUserPreferences = "emailUser";
  static const String passcodeCreateSectionPreferences =
      "passcodeCreateSection";
  static const String usernameFullNamePreferences = "usernameFullName";
  static const String didShowDeviceBioMetricBottomSheet =
      "didShowDeviceBioMetricBottomSheet";
  static const String isDeviceBioMetricIsAvailable =
      "isDeviceBioMetricIsAvailable";
  static const String countryOfResident = "countryOfResident";
  static const String loginUserPreferences = "loginUser";
  static const String userEmailIDPreferences = "userEmailID";
  static const String userIdPreferences = "userId";
  static const String deepLinkPreferences = "deepLink";

  // SharedPreferences Keys Bool
  static const String isInternetDisconnectedBeforeWhileUsingApp =
      "isInternetDisconnectedBeforeWhileUsingApp";
  static const String isSkippedPreference = "isSkipped";
  static const String isUserBioMetricIsEnabledPreference =
      "isUserBioMetricIsEnabled";
  static const String isMPinEnabledPreference = "isMPineEnabled";
  static const String firstLoginPreference = "firstLogin";
  static const String isFirstTimePreference = "isFirstTime";
  static const String isOTPVerifiedPreference = "isOTPVerified";
}
