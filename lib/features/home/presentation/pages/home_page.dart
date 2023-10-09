import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wedge/core/common/cubit/banner_notification_cubit.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/pages/assets_Liabilities_main_page.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/presentation/pages/bank_accounts_page.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/pages/pension_investment_main_page.dart';
import 'package:wedge/features/calculators/calculator_main_page/presentation/pages/calculator_main_page.dart';
import 'package:wedge/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:wedge/features/home/presentation/pages/home_drawer.dart';
import 'package:wedge/features/home/presentation/widgets/asset_liablities_widget.dart';
import 'package:wedge/features/home/presentation/widgets/cashAccountsCards.dart';
import 'package:wedge/features/home/presentation/widgets/financial_tools_widget.dart';
import 'package:wedge/features/home/presentation/widgets/investment_performance_widget.dart';
import 'package:wedge/features/notification/presentation/notification_page.dart';

import '../../../../core/common/cubit/banner_notification_state.dart';
import '../../../../core/config/enviroment_config.dart';
import '../../../../core/contants/string_contants.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../account/my_account/presentation/pages/home_user_name.dart';
import '../../../assets/bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import '../../../auth/hoxton_login/data/models/login_model.dart';
import '../widgets/cashflow_chart_widget.dart';
import '../widgets/top_main_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    listenToInternet();
    changeLoadingState(true);
    handler();
    decodeAccessToken();
    context
        .read<BannerNotificationCubit>()
        .getBannerNotification(isNotificationLoading: false, isInitial: true);
    BioMetricsAuth()
        .checkIfBioMetricAvailableInDeviceNUser(); // BioMetrics checks
    AppAnalytics().trackScreen(
        screenName: "Dashboard", parameters: {'screenName': 'Dashboard'});
    context.read<DashboardCubit>().getDashboardData(shouldLoad: true);
    // update(context);
    super.initState();
  }

  bool showTooltip = false;

  decodeAccessToken() {
    var decodedTokenData = Jwt.parseJwt(LoginModel.fromJson(json.decode(
            locator<SharedPreferences>()
                    .getString(RootApplicationAccess.loginUserPreferences) ??
                ''))
        .accessToken);
    if (decodedTokenData['createdAt'] != null) {
      showTooltip = DateTime.parse(decodedTokenData['createdAt'])
              .toLocal()
              .difference(DateTime.now())
              .inDays
              .abs() <
          7;
    }
  }

  listenToInternet() {
    InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) async {
        switch (status) {
          case InternetConnectionStatus.connected:
            log('Data connection is available.');
            if (locator<SharedPreferences>().getBool(RootApplicationAccess
                    .isInternetDisconnectedBeforeWhileUsingApp) ??
                false) {
              Future.delayed(const Duration(milliseconds: 200), () async {
                // showSnackBar(
                //     context: context,
                //     title:
                //         "Data connection is available. Reloading the data...");
                // await RootApplicationAccess().storeAssets(null);
                // await RootApplicationAccess().storeLiabilities(null);
                // context.read<UserAccountCubit>().getUserDetials();
                // context.read<UserPreferencesCubit>().getUserPreferenceDetails();
                handler();
              });
            }

            break;
          case InternetConnectionStatus.disconnected:
            locator<SharedPreferences>().setBool(
                RootApplicationAccess.isInternetDisconnectedBeforeWhileUsingApp,
                true);
            Future.delayed(const Duration(milliseconds: 300), () {
              showSnackBar(
                  context: context,
                  title: translate?.youAreDisconnectedFromTheInternet ?? "");
            });

            break;
        }
      },
    );
  }

  // Controllers
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPensionsEmpty = false;
  bool isInvestmentsEmpty = false;

  // late final Completer<WebViewController> _completer =
  //     Completer<WebViewController>();
  // static late WebViewController _webViewController;

  // WebView Handler
  handler() {
    // _completer.future.then((controller) {
    //   _webViewController = controller;
    //   Map<String, String> header = {
    //     'authorization': '${Repository().getToken().trim()}'
    //   };
    //   log('${Repository().getToken().trim()}');

    //   _webViewController.loadUrl(
    //       "${getHomeScreenBaseUrl()}dashboard/mobile/performance",
    //       headers: header);
    // });
  }

  // Webview Loading states
  bool _isLoading = false;

  changeLoadingState(val) {
    setState(() {
      _isLoading = val;
    });
  }

  // Navigator
  navigator(Widget screen) async {
    var stocksdata = await Navigator.push(
        context, CupertinoPageRoute(builder: (BuildContext context) => screen));
    changeLoadingState(true);
    handler();
  }

  navigatedToScreens(String url) {
    if (url.contains("Assets-&-Liabilities".toLowerCase())) {
      navigator(AssetsAndLiabilitiesMainPage());
    } else if (url.contains("banks/add".toLowerCase())) {
      navigator(AddBankAccountPage(
        isAppBar: true,
        successPopUp: (_, {required String source}) async {
          if (_) {
            // success
            await RootApplicationAccess().storeAssets();
            await RootApplicationAccess().storeLiabilities();
            if (!mounted) return;
            locator.get<WedgeDialog>().success(
                context: context,
                title: translate?.accountLinkedSuccessfully ?? "",
                info: getPopUpDescription(source),
                buttonLabel: translate?.continueWord ?? "",
                onClicked: () async {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                  changeLoadingState(true);
                  handler();
                  navigator(const BankAccountMain());
                });
          } else {
            // exited
            Navigator.pop(context);
          }
        },
        subtitle: translate?.selectBankSubtitle,
        manualAddButtonAction: () async {
          final data = await Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                  builder: (BuildContext context) => AddBankManualPage(
                        isFromDashboard: true,
                      )));
          changeLoadingState(true);
          handler();
          if (data != null) {
            navigator(const BankAccountMain());
          }
        },
        manualAddButtonTitle: translate?.addManually ?? "",
        placeholder: SEARCH_YOUR_BANK,
        title: translate?.addCashAccounts ?? "",
      ));
    } else if (url.contains("Cash-Accounts".toLowerCase())) {
      if (RootApplicationAccess.assetsEntity?.bankAccounts.isEmpty ?? false) {
        navigator(AddBankAccountPage(
          isAppBar: true,
          successPopUp: (value, {required String source}) async {
            if (value) {
              // success
              await RootApplicationAccess().storeAssets();
              await RootApplicationAccess().storeLiabilities();
              if (!mounted) return;
              locator.get<WedgeDialog>().success(
                  context: context,
                  title: translate?.accountLinkedSuccessfully ?? "",
                  info: getPopUpDescription(source),
                  buttonLabel: translate?.continueWord ?? "",
                  onClicked: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    changeLoadingState(true);
                    handler();
                    navigator(const BankAccountMain());
                  });
            } else {
              // exited
              Navigator.pop(context);
            }
          },
          subtitle: translate?.selectBankSubtitle,
          manualAddButtonAction: () async {
            final data = await Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                    builder: (BuildContext context) => AddBankManualPage(
                          isFromDashboard: true,
                        )));
            changeLoadingState(true);
            handler();
            if (data != null) {
              navigator(const BankAccountMain());
            }
          },
          manualAddButtonTitle: translate?.addManually ?? "",
          placeholder: SEARCH_YOUR_BANK,
          title: translate?.addCashAccounts ?? "",
        ));
      } else {
        // log(url);
        List<String> cashAccountId = url.split("/");
        String id = "";
        if (cashAccountId.length == 5) {
          id = cashAccountId[cashAccountId.length - 1];
        }
        navigator(BankAccountsPage(
          id: id,
        ));
      }
    } else if (url.contains("Pensions-&-Investments".toLowerCase())) {
      navigator(const PensionInvestmentMainPage());
    } else if (url.contains("financial-tools".toLowerCase())) {
      navigator(CalculatorMainPage(
        isFromDashboard: true,
      ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  refreshWeb() {
    handler();
  }

  bool isAssetsAndLiabilityDisconnected = false;
  bool isPensionDisconnected = false;
  bool isInvestmentsDisconnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: appThemeColors!.primary,
      key: scaffoldKey,
      endDrawer: HomeDrawer(
        isPensionsEmpty: isPensionsEmpty,
        isInvestmentsEmpty: isInvestmentsEmpty,
      ),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
            decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: appThemeColors!.gradient!),
        )),
        automaticallyImplyLeading: false,
        backgroundColor: appThemeColors!.primary,
        // shape: RoundedRectangleBorder(
        //     side: BorderSide(color: appThemeColors!.primary!)),
        title: const GetUserName(),
        actions: [
          // getWiredashIcon(context),
          BlocBuilder<BannerNotificationCubit, BannerNotificationState>(
              builder: (context, state) {
            if (state is BannerNotificationLoaded) {
              return state.notificationModel?.isNotEmpty ?? false
                  ? GestureDetector(
                      onTap: () {
                        cupertinoNavigator(
                            context: context,
                            screenName: const NotificationPage(),
                            type: NavigatorType.PUSH);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: badges.Badge(
                            position:
                                badges.BadgePosition.topEnd(top: -4, end: -1),
                            badgeStyle: const badges.BadgeStyle(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1),
                            ),
                            child: SvgPicture.asset(
                                'assets/images/notification_bell.svg')),
                      ),
                    )
                  : SvgPicture.asset('assets/images/notification_bell.svg');
            } else {
              return SvgPicture.asset('assets/images/notification_bell.svg');
            }
          }),
          IconButton(
              onPressed: () {
                setState(() {});
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(
                Icons.menu,
                color: kfontColorLight,
              ))
        ],
      ),
      body: UpgradeAlert(
        upgrader: Upgrader(
            onUpdate: () {
              RootApplicationAccess().logoutAndClearData();
              return true;
            },
            dialogStyle: UpgradeDialogStyle.cupertino,
            durationUntilAlertAgain: const Duration(seconds: 1),
            showReleaseNotes: false,
            messages: MyEnglishMessages(),
            showIgnore: false,
            showLater: false,
            canDismissDialog: false),
        child: WillPopScope(
          onWillPop: () async {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return const LogoutDialog();
                });
            return true;
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: appThemeColors!.bg,
            // child: Stack(
            //   children: [
            //     WebView(
            //         backgroundColor: khomeDashBoard,
            //         gestureNavigationEnabled: true,
            //         debuggingEnabled: true,
            //         navigationDelegate: (NavigationRequest request) {
            //           navigatedToScreens(request.url.toLowerCase());
            //           if (request.url ==
            //               "${getHomeScreenBaseUrl()}dashboard/mobile/performance") {
            //             return NavigationDecision.navigate;
            //           } else {
            //             return NavigationDecision.prevent;
            //           }
            //         },
            //         javascriptChannels: Set.from([
            //           JavascriptChannel(
            //               name: 'YWebViewHandler',
            //               onMessageReceived: (JavascriptMessage eventData) {
            //                 _handleEventsFromJS(eventData.message);
            //               })
            //         ]),
            //         // debuggingEnabled: true,
            //         javascriptMode: JavascriptMode.unrestricted,
            //         onPageFinished: (_) {
            //           changeLoadingState(false);
            //         },
            //         onPageStarted: (_) {
            //           navigatedToScreens(_.toLowerCase());
            //         },
            //         onWebViewCreated: (controller) async {
            //           _completer.complete(controller);
            //         }),
            //     Visibility(
            //         visible: (_isLoading),
            //         child: Center(
            //             child: buildCircularProgressIndicator(width: 200)))
            //   ],
            // )
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoading) {
                  return Center(
                    child: buildCircularProgressIndicator(width: 100),
                  );
                } else if (state is DashboardLoaded) {
                  isPensionsEmpty = state.data.data.pensions.details.isEmpty;
                  isInvestmentsEmpty =
                      state.data.data.investments.details.isEmpty;

                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            TopMainBar(
                              onComplete: () {
                                context
                                    .read<DashboardCubit>()
                                    .getDashboardData(shouldLoad: false);
                              },
                              dashboardDataEntity: state.data,
                            ),
                            showTooltip
                                ? Positioned(
                                    bottom: 110,
                                    left: 50,
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 5, top: 8, bottom: 8),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xCCC6CCD9),
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 0.50,
                                              color: Color(0xFFCFCFCF)),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Column(
                                            children: [
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Icon(
                                                Icons.info_outline,
                                                size: 15,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: size.width * .72,
                                            child: Text(
                                              translate?.updatesWillBeAvailableStartingTomorrowSinceYourAccountWasJustAddedTodayThereAreNoUpdatesAtTheMoment ?? "",
                                              style: SubtitleHelper.h11
                                                  .copyWith(
                                                      color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ), // NetworthChart(), //line chart
                        Padding(
                          padding: const EdgeInsets.all(kpadding),
                          child: Column(
                            children: [
                              AssetLiablitiesHome(
                                dashboardDataEntity: state.data,
                                onComplete: () {
                                  context
                                      .read<DashboardCubit>()
                                      .getDashboardData(shouldLoad: false);
                                },
                              ),

                              BlocBuilder<BannerNotificationCubit,
                                  BannerNotificationState>(
                                builder: (context, state) {
                                  if (state is BannerNotificationLoading &&
                                          !state.isNotificationLoading ||
                                      state
                                          is BannerNotificationInitialLoading) {
                                    return buildCircularProgressIndicator();
                                  } else if (state
                                      is BannerNotificationLoaded) {
                                    if (state.bannerModel?.isEmpty ?? false) {
                                      return const SizedBox.shrink();
                                    }
                                    return Visibility(
                                      visible: state.bannerModel?[0].message !=
                                              null &&
                                          enableUserReferral,
                                      child: Html(
                                        data: state
                                            .bannerModel?[0].message?.mobile,
                                        onAnchorTap:
                                            (url, attributes, element) {
                                          // Put request for banner
                                          context
                                              .read<BannerNotificationCubit>()
                                              .updateNotificationBanner(
                                            isNotificationLoading: false,
                                            params: [
                                              {"id": state.bannerModel?[0].id}
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }
                                  return const SizedBox();
                                },
                              ),
                              CashAccountCards(
                                dashboardDataEntity: state.data,
                                onComplete: ({value}) {
                                  {
                                    context
                                        .read<DashboardCubit>()
                                        .getDashboardData(
                                            shouldLoad: value ?? false);
                                    setState(() {});
                                  }
                                },
                              ), //bank accounts section
                              CashFlowChart(
                                dashboardDataEntity: state.data,
                              ), // bar chart
                              InvestmentPerformance(
                                onComplete: () {
                                  context
                                      .read<DashboardCubit>()
                                      .getDashboardData(shouldLoad: true);
                                  setState(() {});
                                },
                                dashboardDataEntity: state.data,
                              ), //pensions and investments
                              const FinancialTools(),
                              const SizedBox(
                                height: 50,
                              )
                            ],
                          ),
                        )

                        //  EmptyHome() // pensions details
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Text(translate?.error ?? ""),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
