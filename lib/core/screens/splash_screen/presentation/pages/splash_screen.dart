import 'dart:async';
import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/firebase_deeplink.dart';
import 'package:wedge/core/helpers/login_navigator.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/screens/tour/onboarding_screen.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../widget/custom_splace_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  bool isMpinPopVisible = false;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    _startTime();
    initDynamicLinks(navigatorKey.currentContext!);
  }

  //App Life Cycle
  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (isTokenExpired()) {
        fadeNavigator(
            context: navigatorKey.currentContext!,
            screenName: const SplashScreen(),
            type: NavigatorType.PUSHREMOVEUNTIL);
      }
      // Check if Device has biometrics
      // if (locator<SharedPreferences>()
      //         .getBool(RootApplicationAccess.isDeviceBioMetricIsAvialable) ??
      //     false) {
      //   // Check if User has biometrics
      //   if (locator<SharedPreferences>()
      //           .getBool(RootApplicationAccess.isUserBioMetricIsEnabled) ??
      //       false) {
      //     final userdata =
      //         locator<SharedPreferences>().getString(RootApplicationAccess.loginUser) ?? "";
      //     // bioMetricsLogin(userdata);
      //     fadeNavigator(
      //         context: navigatorKey.currentContext!,
      //         screenName: SplashScreen(),
      //         type: NavigatorType.PUSHREMOVEUNTIL);
      //   } else {
      //     passcodeLoginAfterDeviceResumes();
      //   }
      // } else {
      //   passcodeLoginAfterDeviceResumes();
      // }
    }
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

  // Splash Screen Duration
  _startTime() async {
    await BioMetricsAuth().checkIfDeviceHasBiometrics();
    var duration = const Duration(seconds: 1);
    return Timer(duration, _checkIfLoggedIn);
  }

  initDynamicLinks(BuildContext context) {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      // showSnackBar(
      //     context: navigatorKey.currentState!.context,
      //     title: "${dynamicLinkData}");
      final userdata = locator<SharedPreferences>()
              .getString(RootApplicationAccess.loginUserPreferences) ??
          "";
      if (userdata.isEmpty) {
        // showSnackBar(
        //     context: navigatorKey.currentState!.context,
        //     title: "Please login first");
        locator<SharedPreferences>().setString(
            RootApplicationAccess.deepLinkPreferences,
            dynamicLinkData.link.path);
        RootApplicationAccess()
            .navigateToLogin(navigatorKey.currentState!.context);
      } else {
        if (Repository().isTokenExpired()) {
          // if user token expired
          FirebaseDeeplinkNavigation().navigateToScreen(
              saveScreen: true, link: dynamicLinkData.link.path);
          if (BioMetricsAuth().shouldOpenMpin()) {
            // if user has Mpin enabled
            locator<SharedPreferences>()
                .remove(RootApplicationAccess.passcodeCreateSectionPreferences);
            BioMetricsAuth().appPasscodeOpen(userdata,
                context: context, isFromSplash: true);
          } else {
            locator<SharedPreferences>().setString(
                RootApplicationAccess.passcodeCreateSectionPreferences,
                userdata);
            RootApplicationAccess().navigateToLogin(
              context,
            );
          }
        } else {
          FirebaseDeeplinkNavigation().navigateToScreen(
              saveScreen: false, link: dynamicLinkData.link.path);
        }
      }

      // Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {});
  }

  _checkIfLoggedIn() async {
    final PendingDynamicLinkData? pending = await dynamicLinks.getInitialLink();
    final Uri? deepLink = pending?.link;
    if (deepLink != null) {
      locator<SharedPreferences>()
          .setString(RootApplicationAccess.deepLinkPreferences, deepLink.path);
      FirebaseDeeplinkNavigation()
          .navigateToScreen(saveScreen: true, link: deepLink.path);
    } else {
      locator<SharedPreferences>()
          .remove(RootApplicationAccess.deepLinkPreferences);
      FirebaseDeeplinkNavigation.navigationScreen = null;
    }
    bool isFirstTime = locator<SharedPreferences>()
            .getBool(RootApplicationAccess.isFirstTimePreference) ??
        true;
    //TODO: @shahbaz comment after completion of on boarding
    if (isFirstTime) {
      // if (true) {
      _pushOnBoarding();
    } else {
      // Activate CrashAnalytics key
      FirebaseCrashlytics.instance.recordFlutterError;
      setCrashlytics();
      final userdata = locator<SharedPreferences>()
              .getString(RootApplicationAccess.loginUserPreferences) ??
          "";
      if (userdata == "") {
        /// user is logged out
        if (locator<SharedPreferences>()
            .containsKey(RootApplicationAccess.passcodeLoginPreferences)) {
          final logoutData = locator<SharedPreferences>()
                  .getString(RootApplicationAccess.passcodeLoginPreferences) ??
              "";
          BioMetricsAuth().appPasscodeOpen(logoutData,
              context: context, isFromSplash: true);
        } else {
          RootApplicationAccess().navigateToLogin(context);
        }
      } else {
        if (await BioMetricsAuth().getDeviceBioMetric() &&
            await BioMetricsAuth().checkIfDeviceHasBiometrics()) {
          // Check if user has enabled BioMetric
          if (locator<SharedPreferences>().getBool(
                  RootApplicationAccess.isUserBioMetricIsEnabledPreference) ??
              false) {
            // User has BioMetrics enabled
            bioMetricsLogin(userdata);
          } else {
            // If the biometric is not enabled
            passCodeLoginForCheckIfLoginMethod(userdata);
          }
        } else {
          // If the biometric is not enabled
          passCodeLoginForCheckIfLoginMethod(userdata);
        }
      }
    }
  }

  bioMetricsLogin(String userdata) async {
    try {
      final LocalAuthentication auth = LocalAuthentication();
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to move forward',
          authMessages: <AuthMessages>[
            AndroidAuthMessages(
              signInTitle: 'Continue to ${appTheme.clientName} App',
              cancelButton: 'Cancel',
            ),
          ],
          options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
              sensitiveTransaction: true,
              useErrorDialogs: true));
      if (didAuthenticate) {
        LoginNavigator(navigatorKey.currentState!.context,
            LoginModel.fromJson(jsonDecode(userdata)));
      } else {
        passCodeLoginForCheckIfLoginMethod(userdata);
      }
    } catch (e) {
      passCodeLoginForCheckIfLoginMethod(userdata);
    }
  }

  passCodeLoginForCheckIfLoginMethod(String userdata) async {
    final data = LoginModel.fromJson(json.decode(userdata));
    // if (Repository().isTokenExpired()) {
    //TODO: mPin Enable Ckeck
    //   // Is the token expired
    if (BioMetricsAuth().shouldOpenMpin()) {
      // Is Mpin enabled
      await locator<SharedPreferences>()
          .remove(RootApplicationAccess.passcodeCreateSectionPreferences);
      isMpinPopVisible = true;
      BioMetricsAuth().appPasscodeOpen(userdata,
          context: navigatorKey.currentContext!, isFromSplash: true);
    } else {
      locator<SharedPreferences>().setString(
          RootApplicationAccess.passcodeCreateSectionPreferences, userdata);
      RootApplicationAccess().navigateToLogin(navigatorKey.currentContext!,
          forMPin: false); //  Redirect to Login screen
    }
  }

  passcodeLoginAfterDeviceResumes() {
    final userdata = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        "";
    if (!isMpinPopVisible) {
      if (userdata != "") {
        // if user loggedin
        final data = LoginModel.fromJson(json.decode(userdata));
        if (Repository().isTokenExpired()) {
          // if user token expired
          if (BioMetricsAuth().shouldOpenMpin()) {
            locator<SharedPreferences>()
                .remove(RootApplicationAccess.passcodeCreateSectionPreferences);
            // navigatorKey.currentState!.pushNamedAndRemoveUntil(
            //     'login', (Route<dynamic> route) => false);
            // if user has Mpin enabled
            // await locator<SharedPreferences>()
            //     .remove(RootApplicationAccess.passcodeCreateSection);
            // BioMetricsAuth().appPasscodeOpen(userdata,
            //     context: navigatorKey.currentState!.context,
            //     isFromSplash: true);
          } else {
            locator<SharedPreferences>().setString(
                RootApplicationAccess.passcodeCreateSectionPreferences,
                userdata);
            RootApplicationAccess().navigateToLogin(
              navigatorKey.currentState!.context,
            );
          }
        } else {
          LoginNavigator(navigatorKey.currentState!.context, data);
        }
      }
    }
  }

  _pushOnBoarding() {
    Navigator.of(navigatorKey.currentContext!).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 1000),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return OnBoardingScreen();
        },
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return Align(
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomSplashScreen(),
    );
  }
}
