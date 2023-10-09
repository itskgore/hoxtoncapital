import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/widgets/buttons/app_button.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/all_accounts_types/presentation/pages/all_account_types.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';

class BankSuccessBottomNavigationButtons extends StatelessWidget {
  const BankSuccessBottomNavigationButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: appThemeColors!.bg,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
        child: Row(
          children: <Widget>[
            Expanded(
              child: AppButton(
                horizontalPadding: 5,
                onTap: () {
                  final userData = LoginModel.fromJson(jsonDecode(
                      locator<SharedPreferences>().getString(
                              RootApplicationAccess.loginUserPreferences) ??
                          ""));
                  userData.isOnboardingCompleted = true;
                  locator<SharedPreferences>().setString(
                      RootApplicationAccess.loginUserPreferences,
                      jsonEncode(userData));
                  //mix panel Event
                  AppAnalytics().trackEvent(
                    eventName: "hoxton-onboarding-completed-mobile",
                    parameters: {
                      "email Id": locator<SharedPreferences>().getString(
                              RootApplicationAccess.userEmailIDPreferences) ??
                          locator<SharedPreferences>().getString(
                              RootApplicationAccess.emailUserPreferences) ??
                          '',
                      'firstName': getUserNameFromAccessToken()
                    },
                  );
                  fadeNavigator(
                      context: context,
                      screenName: HomePage(),
                      type: NavigatorType.PUSHREMOVEUNTIL);
                },
                borderRadius: 10,
                verticalPadding: 10,
                label: translate!.viewDashboard,
                // viewDashboard
                color: Colors.white,
                style: TitleHelper.h11.copyWith(color: appThemeColors!.primary),
                border: Border.all(color: appThemeColors!.primary!),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: AppButton(
                horizontalPadding: 5,
                onTap: () {
                  cupertinoNavigator(
                      context: context,
                      screenName: AddBankAccountPage(
                        title: '',
                        subtitle: translate!.selectAnyAsset,
                        placeholder: translate!.searchBankInvestmentOrPension,
                        manualAddButtonTitle:
                            translate!.addAssetsLiabilitiesManually,
                        manualAddButtonAction: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      const AllAccountTypes()));
                        },
                        successPopUp: (_, {required String source}) {},
                        isAppBar: false,
                      ),
                      type: NavigatorType.PUSH);
                },
                borderRadius: 10,
                verticalPadding: 10,
                // addMore
                label: translate!.addMore,
                style:
                    TitleHelper.h11.copyWith(color: appThemeColors!.textLight),
              ),
            )
          ],
        ),
      ),
    );
  }
}
