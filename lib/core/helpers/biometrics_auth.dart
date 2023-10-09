import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/screens/splash_screen/presentation/widget/bioMetrics_bg_screen.dart';
import 'package:wedge/core/widgets/bottomSheet/enable_biometrics_sheet.dart';
import 'package:wedge/core/widgets/dialog/wedge_new_custom_dialog_box.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import 'firebase_analytics.dart';
import 'navigators.dart';

class BioMetricsAuth {
  static String biometricTypeEnabled = "Face ID/Fingerprint";
  static String biometricTypeImage = "assets/images/fingerprint 2.svg";
  static String biometricTypeImagePasscode = "assets/images/faceID.svg";
  static bool? isDeviceBioEnabled;

  // Check Passcode will Open
  bool shouldOpenMpin() {
    final userdata = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        "";
    if (userdata.isEmpty) {
      return false;
    }
    final data = LoginModel.fromJson(json.decode(userdata));
    if (data.isMpineEnabled) {
      return true;
    } else {
      return false;
    }
  }

  // check logout user have passcode
  bool hasMpinForLogoutUser() {
    return locator<SharedPreferences>().containsKey(
      RootApplicationAccess.passcodeCreateSectionPreferences,
    );
  }

  // Passcode
  appPasscodeOpen(String userData,
      {required bool isFromSplash, required BuildContext context}) async {
    if ((!BioMetricsAuth().hasMpinForLogoutUser())) {
      String userName = "";
      if (userData.isNotEmpty) {
        final userAccessTokenData = Jwt.parseJwt(
            LoginModel.fromJson(json.decode(userData)).accessToken);
        userName = userAccessTokenData['firstName'];
      } else {
        userName = "";
      }
      bool shouldShowBioMetric =
          await BioMetricsAuth().checkIfDeviceHasBiometrics();
      if (shouldShowBioMetric) {
        shouldShowBioMetric = locator<SharedPreferences>().getBool(
                RootApplicationAccess.isUserBioMetricIsEnabledPreference) ??
            false;
      }

      fadeNavigator(
          context: context,
          screenName: BioMetricsBgScreen(
              userName: userName,
              userData: userData,
              isFromSplash: isFromSplash,
              shouldShowBioMetric: shouldShowBioMetric),
          type: NavigatorType.PUSHREMOVEUNTIL);
      // showModalBottomSheet<void>(
      //   context: navigatorKey.currentState!.context,
      //   backgroundColor: appThemeColors!.primary,
      //   isDismissible: true,
      //   enableDrag: false,
      //   isScrollControlled: true,
      //   transitionAnimationController: null,
      //   builder: (BuildContext context) {
      //     double height = MediaQuery.of(context).size.height;
      //     return Stack(
      //       children: [
      //         BioMetricsBgScreen(logoOpacity: .8, userName: userName),
      //         Positioned(
      //           bottom: 0,
      //           left: 0,
      //           right: 0,
      //           child: SizedBox(
      //               height: height < 700
      //                   ? height * 0.8
      //                   : height < 800
      //                       ? height * .74
      //                       : height * 0.71,
      //               child: ConfirmPasscodeScreen(
      //                 isFromSplash: isFromSplash,
      //                 email: locator<SharedPreferences>()
      //                         .getString(RootApplicationAccess.passCodeMail) ??
      //                     "",
      //               )),
      //         ),
      //       ],
      //     );
      //   },
      // );
    } else {
      RootApplicationAccess().navigateToLogin(context,
          navigatorType: NavigatorType.PUSHREMOVEUNTIL);
    }
  }

  bool isFirstTimeInApp() {
    return locator<SharedPreferences>()
            .getBool(RootApplicationAccess.firstLoginPreference) ??
        true;
  }

  bool hasPassCode() {
    if (locator<SharedPreferences>()
        .containsKey(RootApplicationAccess.isMPinEnabledPreference)) {
      return locator<SharedPreferences>()
              .getBool(RootApplicationAccess.isMPinEnabledPreference) ??
          false;
    } else {
      return false;
    }
  }

  Future<bool> isDeviceSupported() async {
    final LocalAuthentication bioMetrics = LocalAuthentication();
    return await bioMetrics.isDeviceSupported();
  }

  Future<Map<String, dynamic>> checkBiometric() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool canCheckBiometrics = false;
    List<BiometricType> availableBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } catch (e) {
      log("error biometrics $e");
    }
    log("biometric is available: $canCheckBiometrics");
    availableBiometrics = await auth.getAvailableBiometrics();
    log("following biometrics are available");
    if (availableBiometrics.isNotEmpty) {
      for (var ab in availableBiometrics) {
        log("\ttech: $ab");
      }
    } else {
      log("no biometrics are available");
    }
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Sign in using fingerprint',
      );
    } catch (e) {
      log("error using biometric auth: $e");
      return {'hasBio': availableBiometrics.isNotEmpty, "status": false};
    }
    return {'hasBio': availableBiometrics.isNotEmpty, "status": authenticated};
  }

  // Checking if my device has Local Auth and is the loggedIn user has bio metrics setup
  checkIfBioMetricAvailableInDeviceNUser() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!(locator<SharedPreferences>()
            .getBool(RootApplicationAccess.didShowDeviceBioMetricBottomSheet) ??
        false)) {
      bool isUserBioMetricIsEnabled = locator<SharedPreferences>().getBool(
              RootApplicationAccess.isUserBioMetricIsEnabledPreference) ??
          false;
      // If user has no bioMetrics setup
      if (!isUserBioMetricIsEnabled) {
        // checkin if device has the biometrics
        bool deviceHasBioMetrics =
            await checkIfDeviceHasBiometrics(); // checkin if device has biometrics
        if (deviceHasBioMetrics) {
          // setting device has bioMetrics
          locator<SharedPreferences>().setBool(
              RootApplicationAccess.isDeviceBioMetricIsAvailable, true);
          // it does
          showModalBottomSheet<void>(
            context: navigatorKey.currentState!.context,
            backgroundColor: appThemeColors!.bg,
            enableDrag: false,
            isDismissible: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            )),
            builder: (BuildContext context) {
              double height = MediaQuery.of(context).size.height;
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      )),
                  height: height < 700
                      ? height * .8
                      : height < 800
                          ? height * .74
                          : height * 0.52,
                  child: const EnableBioMetricSheet(),
                ),
              );
            },
          ).then((value) {
            locator<SharedPreferences>().setBool(
                RootApplicationAccess.didShowDeviceBioMetricBottomSheet, true);
          });
        } else {
          locator<SharedPreferences>().setBool(
              RootApplicationAccess.isDeviceBioMetricIsAvailable, false);
        }
      }
    }
  }

  bioMetricsLogin(String userdata) async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool didAuthenticate = await auth.authenticate(
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Continue to ${appTheme.clientName} App',
              cancelButton: 'Cancel',
            ),
          ],
          localizedReason: 'Use your fingerprint to continue the app',
          options: AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: Platform.isAndroid,
              useErrorDialogs: true));
      if (didAuthenticate) {
        locator<SharedPreferences>()
            .setString(RootApplicationAccess.loginUserPreferences, userdata);

        String UserID = locator<SharedPreferences>()
                .getString(RootApplicationAccess.userIdPreferences) ??
            "";
        AppAnalytics().trackLogin(
            userId: UserID,
            loginType: "biometric",
            email: locator<SharedPreferences>()
                    .getString(RootApplicationAccess.userEmailIDPreferences) ??
                locator<SharedPreferences>()
                    .getString(RootApplicationAccess.emailUserPreferences) ??
                '');

        LoginNavigator(navigatorKey.currentState!.context,
            LoginModel.fromJson(jsonDecode(userdata)));
      }
    } on PlatformException catch (e) {
      if (e.code == "LockedOut" ||
          e.code == "PermanentlyLockedOut" ||
          e.message ==
              "The operation was canceled because the API is locked out due to too many attempts. This occurs after 5 failed attempts, and lasts for 30 seconds") {
        showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentState!.context,
          builder: (BuildContext context) {
            return WillPopScope(
              onWillPop: () async {
                // Return false to restrict the back button when the dialog is visible
                return false;
              },
              child: NewCustomDialogBox(
                isSuccess: false,
                showWarningIcon: true,
                onPressedPrimary: () async {
                  Navigator.pop(context);
                },
                title: '${BioMetricsAuth.biometricTypeEnabled} Failure',
                primaryButtonText: "Continue",
                description:
                    "${BioMetricsAuth.biometricTypeEnabled} has failed multiple times,\nPlease use Hoxton Password to continue.",
              ),
            );
          },
        );
      }
    }
  }

  Future<bool> checkIfDeviceHasBiometrics() async {
    // checkin if device has biometrics
    final localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      isDeviceBioEnabled = canCheckBiometrics;
      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();
        // AppFirebaseAnalytics().trackEvent(
        //     eventName: "bioMetricsType",
        //     parameters: {"list_of_biometrics": availableBiometrics.toString()});

        if (availableBiometrics.contains(BiometricType.fingerprint)) {
          // Fingerprint authentication is available
          biometricTypeEnabled = "Fingerprint";
          biometricTypeImage = "assets/images/fingerprint_bottom_sheet.svg";
          biometricTypeImagePasscode = "assets/images/fingerprint_passcode.png";
          if (Platform.isIOS) {
            return false;
          }
          return true;
          log('Fingerprint authentication is available');
        }

        if (availableBiometrics.contains(BiometricType.face)) {
          // Face ID authentication is available
          biometricTypeEnabled = "Face ID";
          biometricTypeImage = "assets/images/fingerprint 2.svg";
          biometricTypeImagePasscode = "assets/images/faceID.svg";

          if (Platform.isAndroid) {
            return false;
          }
          return true;
          log('Face ID authentication is available');
        }

        if (availableBiometrics.contains(BiometricType.weak) ||
            availableBiometrics.contains(BiometricType.strong)) {
          // Face ID
          // Face ID authentication is available
          biometricTypeEnabled = "Fingerprint";
          biometricTypeImage = "assets/images/fingerprint_bottom_sheet.svg";
          biometricTypeImagePasscode = "assets/images/fingerprint_passcode.png";
          return true;
          log('Face ID authentication is available');
        }
      } else {
        return false;
        log('Biometric authentication is not available on this device.');
      }
      return false;
    } catch (e) {
      return false;
      log('An error occurred: $e');
    }
  }

  Future<bool> getDeviceBioMetric() async {
    return BioMetricsAuth.isDeviceBioEnabled ??
        locator<SharedPreferences>()
            .getBool(RootApplicationAccess.isDeviceBioMetricIsAvailable) ??
        await BioMetricsAuth().checkIfDeviceHasBiometrics();
  }
}
