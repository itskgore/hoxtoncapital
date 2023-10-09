import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/account/account_main/presentation/pages/account%20_main_page.dart';
import 'package:wedge/features/assets/all_assets/presentation/pages/add_assets_page.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/pages/assets_Liabilities_main_page.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/pages/pension_investment_main_page.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/presentation/pages/add_liabilities_page.dart';
import 'package:wedge/features/support/presentation/pages/support.dart';
import 'package:wedge/features/user_services/user_services_main/presentation/pages/user_services_main_page.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/pages/wealth_valt_main.dart';

import '../../features/assets/bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import '../config/app_config.dart';

class FirebaseDeeplinkNavigation {
  static Widget? navigationScreen;

  navigateToScreen({required bool saveScreen, required String link}) {
    if (saveScreen) {
      if (link.contains("pensions")) {
        FirebaseDeeplinkNavigation.navigationScreen = PensionMainPage();
      }
      if (link.contains("assetsLiabilities")) {
        FirebaseDeeplinkNavigation.navigationScreen =
            AssetsAndLiabilitiesMainPage();
      }
      if (link.contains("bank")) {
        FirebaseDeeplinkNavigation.navigationScreen = BankAccountMain();
      }
      if (link.contains("wealth-vault/my-documents")) {
        FirebaseDeeplinkNavigation.navigationScreen = WealthValtMainPage();
      }
      if (link.contains("wealth-vault/my-documents")) {
        FirebaseDeeplinkNavigation.navigationScreen = WealthValtMainPage();
      }
      if (link.contains("dashboard")) {
        FirebaseDeeplinkNavigation.navigationScreen = const HomePage();
      }
      if (link.contains("support")) {
        FirebaseDeeplinkNavigation.navigationScreen = SupportAccount();
      }
      if (link.contains("services/advisory-team")) {
        FirebaseDeeplinkNavigation.navigationScreen = UserServicesMainPage();
      }
      if (link.contains("add-assets")) {
        FirebaseDeeplinkNavigation.navigationScreen = AddAssetsPage();
      }
      if (link.contains("add-liabilities")) {
        FirebaseDeeplinkNavigation.navigationScreen = AddLiabilitiesPage();
      }
      if (link.contains("my-account")) {
        FirebaseDeeplinkNavigation.navigationScreen = const AccountPage();
      }
      if (link.contains("pension-investments")) {
        FirebaseDeeplinkNavigation.navigationScreen =
            const PensionInvestmentMainPage();
      }
    } else {
      if (link.contains("pensions")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: PensionMainPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("assetsLiabilities")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: AssetsAndLiabilitiesMainPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("bank")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: BankAccountMain(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("wealth-vault/my-documents")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: WealthValtMainPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }

      if (link.contains("dashboard")) {
        fadeNavigator(
            context: navigatorKey.currentState!.context,
            screenName: const HomePage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);
            });
      }
      if (link.contains("support")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: SupportAccount(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("services/advisory-team")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: UserServicesMainPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("add-assets")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: AddAssetsPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("add-liabilities")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: AddLiabilitiesPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("my-account")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: const AccountPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
      if (link.contains("pension-investments")) {
        cupertinoNavigator(
            context: navigatorKey.currentState!.context,
            screenName: const PensionInvestmentMainPage(),
            type: NavigatorType.PUSH,
            then: (_) {
              locator<SharedPreferences>()
                  .remove(RootApplicationAccess.deepLinkPreferences);

              cupertinoNavigator(
                  context: navigatorKey.currentState!.context,
                  screenName: const HomePage(),
                  type: NavigatorType.PUSHREMOVEUNTIL);
            });
      }
    }
  }

  Widget? getWidgetToNavigate() {
    final link = locator<SharedPreferences>()
        .getString(RootApplicationAccess.deepLinkPreferences);
    if (link != null) {
      if (link.contains("pensions")) {
        return PensionMainPage();
      }
      if (link.contains("assetsLiabilities")) {
        return AssetsAndLiabilitiesMainPage();
      }
      if (link.contains("bank")) {
        return BankAccountMain();
      }
      if (link.contains("wealth-vault/my-documents")) {
        return WealthValtMainPage();
      }
      if (link.contains("wealth-vault/my-documents")) {
        return WealthValtMainPage();
      }
      if (link.contains("dashboard")) {
        return const HomePage();
      }
      if (link.contains("support")) {
        return SupportAccount();
      }
      if (link.contains("services/advisory-team")) {
        return UserServicesMainPage();
      }
      if (link.contains("add-assets")) {
        return AddAssetsPage();
      }
      if (link.contains("add-liabilities")) {
        return AddLiabilitiesPage();
      }
      if (link.contains("my-account")) {
        return const AccountPage();
      }
      if (link.contains("pension-investments")) {
        return const PensionInvestmentMainPage();
      }
    }
    return null;
  }
}
