import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/helpers/firebase_deeplink.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/presentation/pages/userdata_summery_page.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/personal_details/presentation/pages/welcome_screen.dart';
import 'package:wedge/features/auth/terms_and_condition/presentation/pages/terms_and_condi_page.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';

import '../../features/auth/personal_details/presentation/pages/personal_details_screen.dart';
import '../../features/home/presentation/cubit/disconnected_accounts_cubit.dart';

class LoginNavigator {
  Future<Widget?> getNavigation() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

    final PendingDynamicLinkData? pending = await dynamicLinks.getInitialLink();
    final Uri? deepLink = pending?.link;
    if (deepLink != null) {
      FirebaseDeeplinkNavigation()
          .navigateToScreen(saveScreen: true, link: deepLink.path);
      return FirebaseDeeplinkNavigation.navigationScreen;
    } else {
      return null;
    }
  }

  LoginNavigator(context, LoginUserEntity data) {
    if (data.accessToken.isNotEmpty) {
      if (!data.isProfileCompleted) {
        _navigateTo(
            const PersonalDetailsPage(),
            context,
            deeplink: locator<SharedPreferences>()
                .getString(RootApplicationAccess.deepLinkPreferences),
            isDeepLink:
                FirebaseDeeplinkNavigation().getWidgetToNavigate() != null,
            data,
            isHome: true);
      } else if (!data.isOnboardingCompleted && data.lastLogin != null) {
        bool? isSkipped = locator<SharedPreferences>()
            .getBool(RootApplicationAccess.isSkippedPreference);
        if (isSkipped ?? false) {
          _navigateTo(
              FirebaseDeeplinkNavigation().getWidgetToNavigate() ?? HomePage(),
              context,
              deeplink: locator<SharedPreferences>()
                  .getString(RootApplicationAccess.deepLinkPreferences),
              isDeepLink:
                  FirebaseDeeplinkNavigation().getWidgetToNavigate() != null,
              data,
              isHome: true);
        } else {
          _firstVisit(context);
        }
      } else if (data.isOnboardingCompleted) {
        _navigateTo(
            FirebaseDeeplinkNavigation().getWidgetToNavigate() ?? HomePage(),
            context,
            deeplink: locator<SharedPreferences>()
                .getString(RootApplicationAccess.deepLinkPreferences),
            isDeepLink:
                FirebaseDeeplinkNavigation().getWidgetToNavigate() != null,
            data,
            isHome: true);
      } else {
        bool? isSkipped = locator<SharedPreferences>()
            .getBool(RootApplicationAccess.isSkippedPreference);
        if (isSkipped ?? false) {
          _navigateTo(
              FirebaseDeeplinkNavigation().getWidgetToNavigate() ?? HomePage(),
              context,
              deeplink: locator<SharedPreferences>()
                  .getString(RootApplicationAccess.deepLinkPreferences),
              isDeepLink:
                  FirebaseDeeplinkNavigation().getWidgetToNavigate() != null,
              data,
              isHome: true);
        } else {
          _navigateTo(
            UserDataSummeryPage(),
            isDeepLink:
                FirebaseDeeplinkNavigation().getWidgetToNavigate() != null,
            deeplink: locator<SharedPreferences>()
                .getString(RootApplicationAccess.deepLinkPreferences),
            context,
            data,
          );
        }
      }
      // }
    }
  }

  _firstVisit(BuildContext context) async {
    try {
      await RootApplicationAccess().storeAssets();
      await RootApplicationAccess().storeLiabilities();
      RootApplicationAccess().refreshFCMToken();
    } catch (e) {
      // throw handleThrownException(e);
    }

    cupertinoNavigator(
        context: context,
        screenName: const WelcomeScreen(),
        type: NavigatorType.PUSHREMOVEUNTIL);
  }
}

_navigateTo(page, context, LoginUserEntity data,
    {bool? isHome, bool? isDeepLink, String? deeplink}) async {
  locator<SharedPreferences>().setBool(
      RootApplicationAccess.isInternetDisconnectedBeforeWhileUsingApp, false);

  final decodedTokenData = Jwt.parseJwt(LoginModel.fromJson(json.decode(
          locator<SharedPreferences>()
                  .getString(RootApplicationAccess.loginUserPreferences) ??
              ''))
      .accessToken);
  String countryOfResident = decodedTokenData['countryOfResident'] ?? "";
  if (countryOfResident != '') {
    locator<SharedPreferences>()
        .setString(RootApplicationAccess.countryOfResident, countryOfResident);
  }

  unawaited(RootApplicationAccess().storeAssets());
  unawaited(RootApplicationAccess().storeLiabilities());
  navigatorKey.currentContext!
      .read<DisconnectedAccountsCubit>()
      .getDisconnectedAccountData();
  // RootApplicationAccess().storeUserDetails(null);
  // showSnackBar(context: context, title: "Navigate to: ${page}");
  FirebaseDeeplinkNavigation.navigationScreen = null;

  if (!data.isTermsAndConditionsAccepted) {
    cupertinoNavigator(
        context: context,
        screenName: TermsConditionPage(
          displayUrl: appTheme.termsCondition!,
          page: page,
        ),
        type: NavigatorType.PUSHREMOVEUNTIL);

    FirebaseDeeplinkNavigation.navigationScreen = null;
  } else {
    if (isHome != null) {
      try {
        locator<SharedPreferences>()
            .setBool(RootApplicationAccess.firstLoginPreference, false);
        //blow line are commented because these taking time to get data and app going to be slow
        // unawaited(RootApplicationAccess().getAssetsLiabilities());
        // unawaited(RootApplicationAccess().storeAssets(null));
        await RootApplicationAccess().refreshFCMToken();
        if (isDeepLink ?? false) {
          FirebaseDeeplinkNavigation()
              .navigateToScreen(saveScreen: false, link: deeplink ?? "");
          // cupertinoNavigator(
          //     context: context, screenName: page, type: NavigatorType.PUSH);
          FirebaseDeeplinkNavigation.navigationScreen = null;
        } else {
          cupertinoNavigator(
              context: context,
              screenName: page,
              type: NavigatorType.PUSHREMOVEUNTIL);
        }
        FirebaseDeeplinkNavigation.navigationScreen = null;
      } catch (e) {
        if (isDeepLink ?? false) {
          FirebaseDeeplinkNavigation()
              .navigateToScreen(saveScreen: false, link: deeplink ?? "");
          // cupertinoNavigator(
          //     context: context, screenName: page, type: NavigatorType.PUSH);
          FirebaseDeeplinkNavigation.navigationScreen = null;
        } else {
          cupertinoNavigator(
              context: context,
              screenName: page,
              type: NavigatorType.PUSHREMOVEUNTIL);
        }
        FirebaseDeeplinkNavigation.navigationScreen = null;
        throw handleThrownException(e);
      }
    }
  }
}
