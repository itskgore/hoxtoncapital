import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/all_assets/presentation/pages/add_assets_page.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/pages/assets_Liabilities_main_page.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/presentation/pages/add_liabilities_page.dart';
import 'package:wedge/features/support/presentation/pages/support.dart';
import 'package:wedge/features/user_services/user_services_main/presentation/pages/user_services_main_page.dart';
import 'package:wedge/features/wealth_vault/documents/presentation/pages/wealth_valt_main.dart';

import '../../../../core/config/enviroment_config.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../core/widgets/dialog/wedge_new_custom_dialog_box.dart';
import '../../../../core/widgets/new_bedge.dart';
import '../../../account/account_main/presentation/pages/account _main_page.dart';
import '../../../account/my_account/presentation/cubit/user_account_cubit.dart';
import '../../../account/my_account/presentation/pages/user_account_main.dart';
import '../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import '../../../assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import '../../../assets/pension/pension_main/presentation/pages/pension_main_page.dart';
import '../../../invite_friends/presentation/pages/invite_friends_screen.dart';
import '../cubit/disconnected_accounts_cubit.dart';
import '../cubit/disconnected_accounts_state.dart';

class HomeDrawer extends StatefulWidget {
  final bool isPensionsEmpty;
  final bool isInvestmentsEmpty;

  const HomeDrawer({
    Key? key,
    this.isPensionsEmpty = false,
    this.isInvestmentsEmpty = false,
  }) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  navigateTo(Widget child, BuildContext context) {
    Navigator.push(context,
            CupertinoPageRoute(builder: (BuildContext context) => child))
        .then((value) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()));
    });
  }

  // Time Period set for the New Badge
  bool newBadgeVisibility({required String FeatureName}) {
    for (int e = 0; newFeatures.length > e; e++) {
      DateTime formattedLaunchDate =
          DateFormat('dd-MM-yyyy').parse(newFeatures[e].launchDate);
      Duration currentAndLaunchDateDifference =
          formattedLaunchDate.difference(DateTime.now());
      int badgeHideRemainingDays = currentAndLaunchDateDifference.inDays +
          int.parse(newFeatures[e].durationDays);
      if (newFeatures[e].name.toLowerCase() == FeatureName.toLowerCase()) {
        if (badgeHideRemainingDays > 0) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
            colors: appThemeColors!.gradient!),
      ),
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<DisconnectedAccountsCubit, DisconnectedAccountsState>(
        builder: (context, state) {
          final cubit = context.read<DisconnectedAccountsCubit>();
          return Drawer(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: appThemeColors!.gradient!)),
              child: SafeArea(
                bottom: false,
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Image.asset(
                                appTheme.appImage!.appLogoLight!,
                                width: 120,
                                height: 50,
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Color(0xfffD6D6D6),
                                  size: 30,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Divider(
                          color: Color(0xfffd6d6d6),
                          height: 0.02,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SingleChildScrollView(
                              child: Column(
                            children: [
                              createDrawerItem(
                                  image: "${appIcons.homePaths!.drawerIcon}",
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                HomePage()));
                                  },
                                  title: translate!.home),
                              createDrawerItem(
                                  image: "${appIcons.assetsPaths!.drawerIcon}",
                                  showDisconnectedIcon:
                                      cubit.isAssetsAndLiabilityDisconnected,
                                  onTap: () {
                                    navigateTo(AssetsAndLiabilitiesMainPage(),
                                        context);
                                  },
                                  title: translate!.assetsAndLiabilities),
                              createDrawerItem(
                                  image: "assets/icons/drawerIcons/Pension.svg",
                                  showDisconnectedIcon:
                                      cubit.isPensionDisconnected,
                                  onTap: () {
                                    if (widget.isPensionsEmpty) {
                                      navigateTo(
                                          AddBankAccountPage(
                                            isAppBar: true,
                                            successPopUp: (_,
                                                {required String
                                                    source}) async {
                                              if (_) {
                                                // success
                                                await RootApplicationAccess()
                                                    .storeAssets();
                                                await RootApplicationAccess()
                                                    .storeLiabilities();
                                                if (!mounted) return;
                                                locator
                                                    .get<WedgeDialog>()
                                                    .success(
                                                        context: context,
                                                        title: translate
                                                                ?.accountLinkedSuccessfully ??
                                                            '',
                                                        info:
                                                            getPopUpDescription(
                                                                source),
                                                        buttonLabel: translate
                                                                ?.continueWord ??
                                                            "",
                                                        onClicked: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      PensionMainPage()));
                                                        });
                                              } else {
                                                // exited
                                                Navigator.pop(context);
                                              }
                                            },
                                            subtitle: translate!
                                                .orSelectFromthePensionProvidersBelow,
                                            manualAddButtonAction: () async {
                                              final data = await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AddPensionManualPage()));
                                              // resetState();
                                            },
                                            manualAddButtonTitle:
                                                translate!.addManually,
                                            placeholder: translate!
                                                .searchYourPensionProvider,
                                            title:
                                                "${translate!.add} ${translate!.pensions}",
                                          ),
                                          context);
                                    } else {
                                      navigateTo(PensionMainPage(), context);
                                    }
                                  },
                                  title: translate!.pensions),
                              createDrawerItem(
                                  image:
                                      "${appIcons.pensionInvestPaths!.drawerIcon}",
                                  showDisconnectedIcon:
                                      cubit.isInvestmentsDisconnected,
                                  onTap: () {
                                    if (widget.isInvestmentsEmpty) {
                                      navigateTo(
                                          AddBankAccountPage(
                                            isAppBar: true,
                                            successPopUp: (_,
                                                {required String
                                                    source}) async {
                                              if (_) {
                                                // success
                                                await RootApplicationAccess()
                                                    .storeAssets();
                                                await RootApplicationAccess()
                                                    .storeLiabilities();
                                                if (!mounted) return;
                                                locator
                                                    .get<WedgeDialog>()
                                                    .success(
                                                        context: context,
                                                        title: translate
                                                                ?.accountLinkedSuccessfully ??
                                                            "",
                                                        info:
                                                            getPopUpDescription(
                                                                source),
                                                        buttonLabel: translate
                                                            ?.continueWord,
                                                        onClicked: () async {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          setState(() {});
                                                          Navigator.push(
                                                              context,
                                                              CupertinoPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      InvestmentsMainPage()));
                                                        });
                                              } else {
                                                // exited
                                                Navigator.pop(context);
                                              }
                                            },
                                            subtitle: translate!
                                                .orSelectFromTheBrokersBelow,
                                            manualAddButtonAction: () async {
                                              await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          AddInvestmentManualPage()));
                                            },
                                            manualAddButtonTitle:
                                                translate!.addManually,
                                            placeholder: translate!
                                                .addInvestmentPlatforms,
                                            title: translate!
                                                .addInvestmentPlatforms,
                                          ),
                                          context);
                                    } else {
                                      navigateTo(
                                          InvestmentsMainPage(), context);
                                    }
                                  },
                                  title: translate!.investments),
                              // createDrawerItem(
                              //     image: "drawer_wealth_vault",
                              //     onTap: () {},
                              //     title: "Wealth Vault"),
                              // createDrawerItem(
                              //     image:
                              //         "${appIcons.financialCalPaths!.drawerIcon}",
                              //     onTap: () {
                              //       Navigator.pop(context);

                              //       Navigator.push(
                              //           context,
                              //           CupertinoPageRoute(
                              //               builder: (BuildContext context) =>
                              //                   CalculatorMainPage()));
                              //     },
                              //     title: translate.financialCalculator),
                              createDrawerItem(
                                  image:
                                      "${appIcons.wealthVaultPaths!.drawerIcon}",
                                  onTap: () {
                                    Navigator.pop(context);

                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                WealthValtMainPage()));
                                  },
                                  title: translate!.wealthVault),

                              createDrawerItem(
                                  image: "${appIcons.supportPaths!.drawerIcon}",
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const SupportAccount()));
                                  },
                                  title: translate!.support),
                              appTheme.hasMyServices ?? false
                                  ? createDrawerItem(
                                      image:
                                          "assets/icons/drawerIcons/my_hoxton.svg",
                                      onTap: () {
                                        Navigator.pop(context);

                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    UserServicesMainPage()));
                                      },
                                      title: translate!.services)
                                  : Container(),
                            ],
                          )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: appThemeColors!.disableLight,
                          height: 0.02,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                createDrawerItem(
                                    image:
                                        "${appIcons.assetsPaths!.drawerIcon}",
                                    width: 28,
                                    onTap: () {
                                      navigateTo(AddAssetsPage(), context);
                                    },
                                    title: translate!.addAssets),
                                createDrawerItem(
                                    image:
                                        "${appIcons.liabilityPaths!.drawerIcon}",
                                    width: 30,
                                    onTap: () {
                                      navigateTo(AddLiabilitiesPage(), context);
                                    },
                                    title: translate!.addLiabilities),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Divider(
                          color: appThemeColors!.disableLight,
                          height: 0.02,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        appTheme.clientName!.toLowerCase() != "wedge"
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    createDrawerItem(
                                        image:
                                            "${appIcons.myAccountPaths!.drawerIcon}",
                                        onTap: () {
                                          AppAnalytics().trackScreen(
                                              screenName: "My Account",
                                              parameters: {
                                                'screenName': 'My Account'
                                              });
                                          navigateTo(
                                              const AccountPage(), context);
                                        },
                                        title: translate!.myAccount),
                                    Visibility(
                                      visible: enableUserReferral,
                                      child: createDrawerItem(
                                        image: "${appIcons.inviteFriendsIcon}",
                                        onTap: () {
                                          cupertinoNavigator(
                                              context: context,
                                              screenName:
                                                  const InviteFriendsScreen(),
                                              type: NavigatorType.PUSH);
                                        },
                                        title: translate!.inviteFriends,
                                      ),
                                    ),
                                    createDrawerItem(
                                        image: "${appIcons.logoutIcon}",
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WillPopScope(
                                                    onWillPop: () async {
                                                      // Return false to restrict the back button when the dialog is visible
                                                      return false;
                                                    },
                                                    child:
                                                        const LogoutDialog());
                                              });
                                        },
                                        title: translate!.logOut),
                                  ],
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  children: [
                                    BlocBuilder<UserAccountCubit,
                                        UserAccountState>(
                                      builder: (context, state) {
                                        if (state is UserAccountLoading) {
                                          return buildCircularProgressIndicator();
                                        } else if (state is UserAccountLoaded) {
                                          return createDrawerItem(
                                              image:
                                                  "${appIcons.myAccountPaths!.drawerIcon}",
                                              onTap: () {
                                                // Navigator.pop(context);
                                                AppAnalytics().trackScreen(
                                                    screenName: "My Account",
                                                    parameters: {
                                                      'screenName': 'My Account'
                                                    });
                                                navigateTo(
                                                    UserAccountMain(), context);
                                              },
                                              title: translate!.myAccount);
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),

                                    createDrawerItem(
                                        image: "${appIcons.logoutIcon}",
                                        onTap: () {
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return WillPopScope(
                                                    onWillPop: () async {
                                                      // Return false to restrict the back button when the dialog is visible
                                                      return false;
                                                    },
                                                    child:
                                                        const LogoutDialog());
                                              });
                                        },
                                        title: translate!.logOut),

                                    // Divider(
                                    //   color: Colors.grey[400],
                                    // ),
                                    // ListTile(
                                    //   leading: Icon(
                                    //     Icons.info_outline,
                                    //     color: Colors.grey[400],
                                    //   ),
                                    //   title: Text(
                                    //     locator<PackageInfo>().version +
                                    //         " ( ${locator<PackageInfo>().buildNumber} )",
                                    //     style: TextStyle(
                                    //         color: Colors.grey[400],
                                    //         fontSize: 18.0,
                                    //         fontWeight: FontWeight.w300),
                                    //   ),
                                    // )
                                  ],
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: createDrawerItem(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.grey[400],
                              ),
                              image: "drawer_logout",
                              onTap: () {},
                              title:
                                  "${locator<PackageInfo>().version} ( ${locator<PackageInfo>().buildNumber} )"),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  ListTile createDrawerItem(
      {required String image,
      required String title,
      Icon? icon,
      double? width,
      bool showDisconnectedIcon = false,
      required Function() onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.all(05),
      onTap: onTap,
      leading: icon ??
          SvgPicture.asset(
            image,
            width: width ?? 20,
          ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w200,
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      // Checking if account is Disconnected show warning Icon first
      trailing: showDisconnectedIcon
          ? Visibility(
              visible: showDisconnectedIcon,
              child: SvgPicture.asset(
                "assets/icons/warning.svg",
                height: 25,
                // fit: BoxFit.cover,
              ),
            )
          : Visibility(
              visible: newBadgeVisibility(FeatureName: title),
              child: const NewBadge()),
    );
  }
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({Key? key}) : super(key: key);

  Future setPasscodeLogin() async {
    final userdata = locator<SharedPreferences>()
            .getString(RootApplicationAccess.loginUserPreferences) ??
        "";
    LoginModel.fromJson(json.decode(userdata));
    if (BioMetricsAuth().shouldOpenMpin()) {
      await locator<SharedPreferences>().remove(
        RootApplicationAccess.passcodeCreateSectionPreferences,
      );
      await locator<SharedPreferences>().setString("passcodeLogin", userdata);
    } else {
      await locator<SharedPreferences>().setString(
          RootApplicationAccess.passcodeCreateSectionPreferences, userdata);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NewCustomDialogBox(
      isTitleIconVisible: false,
      title: translate!.logoutTitle,
      description: translate!.logoutDescription,
      primaryButtonText: translate!.yes.toString().toUpperCase(),
      onPressedPrimary: () {
        context.read<UserAccountCubit>().removeUserData();
        setPasscodeLogin().then((value) {
          RootApplicationAccess().logoutAndClearData(isFromHome: true);
        });
      },
      secondaryButtonText: translate!.cancel.toUpperCase(),
      onPressedSecondary: () {
        Navigator.pop(context);
      },
    );
  }
}
