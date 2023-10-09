import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/theme_model.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/bloc/cubit/assets_and_liabilities_state.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/widgets/assets_liabilities_chart.dart';
import 'package:wedge/features/assets/assets_liablities_main/presentation/widgets/main_assets_widget.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/pages/add_crypto_manual_page.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/pages/crypto_main_page.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/pages/add_custom_assets_page.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/presentation/pages/custom_assets_main_page.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/add_property_page.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/pages/properties_main_page.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/presentation/pages/add_stocks_page.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/pages/add_stocks_main_page.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/pages/vehicles_main_page.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/pages/add_add_credit_card_debt_page.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/pages/credit_card_debt_main_page.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/pages/mortgage_main_page.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/presentation/pages/add_other_liabilities_page.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/presentation/pages/other_liabilities_main_page.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/presentation/pages/add_personal_loan_page.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/presentation/pages/personal_loan_main_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/pages/vehicle_loan_main_page.dart';

import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import '../../data/Models/assets_liabilities_model.dart';
import '../bloc/cubit/assets_and_liablities_cubit.dart';
import '../widgets/liability_chart.dart';

class AssetsAndLiabilitiesMainPage extends StatefulWidget {
  // AssetsAndLiabilitiesMainPage({Key? key}) : super(key: key);

  @override
  _AssetsAndLiabilitiesMainPageState createState() =>
      _AssetsAndLiabilitiesMainPageState();
}

class _AssetsAndLiabilitiesMainPageState
    extends State<AssetsAndLiabilitiesMainPage> {
  List<bool> isSelected = [true, false];

  final Color _emptyColor = const Color(0xfffF0F1E8);

  final _controller = ScrollController();

  resetState() {
    setState(() {
      context
          .read<AssetsAndLiabilitiesCubit>()
          .getAssetsAndLiabilities(coldUpdate: true);
    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    context.read<AssetsAndLiabilitiesCubit>().getAssetsAndLiabilities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: appThemeColors!.bg,
      appBar: AppBar(
        title: Text(
          "${translate!.assets} & ${translate!.liabilities}",
          style: appbarStyle(),
        ),
        actions: [
          getWireDashIcon(context),
        ],
        leading: IconButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            icon:
                Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back)),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: kpadding, right: kpadding),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return ToggleButtons(
                              constraints: BoxConstraints.expand(
                                  width: constraints.maxWidth / 2.1),
                              fillColor: appThemeColors!.primary,
                              selectedColor: appThemeColors!.textLight,
                              textStyle: SubtitleHelper.h11
                                  .copyWith(color: kfontColorDark),
                              borderRadius: BorderRadius.circular(10.0),
                              onPressed: (index) {
                                setState(() {
                                  if (index == 0) {
                                    isSelected = [true, false];
                                  } else {
                                    isSelected = [false, true];
                                  }
                                });
                              },
                              isSelected: isSelected,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Center(child: Text(ASSETS)),
                                ),
                                Container(
                                    // width:
                                    // MediaQuery.of(context).size.width / 2,
                                    child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Center(child: Text(LIABILITIES)),
                                )),
                              ]);
                        },
                      )),
                ),
                verticalSpacing()
              ],
            )),
      ),
      body: BlocConsumer<AssetsAndLiabilitiesCubit, AssetsAndLiabilitiesState>(
        listener: (con, state) {
          if (state is AssetsAndLiabilitiesError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is AssetsAndLiabilitiesLoaded) {
            return Padding(
              padding: const EdgeInsets.only(left: kpadding, right: kpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: isSelected[0]
                        ? _assetList(state.assetsLiabilitiesData)
                        : _liabilitiesList(state.assetsLiabilitiesData),
                  )
                ],
              ),
            );
          } else if (state is AssetsAndLiabilitiesError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else if (state is AssetsAndLiabilitiesLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 100),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _assetList(AssetsLiabilitiesModel state) {
    var assetsData = state.assets;
    AssetsTheme assetColors = appThemeColors!.charts!.assets!;
    return ListView(
      controller: _controller,
      children: [
        DashboardValueContainer(
            mainValue:
                "${assetsData.summary.total.currency} ${assetsData.summary.total.amount}",
            mainTitle: translate!.totalAssetValue,
            leftValue: "${assetsData.summary.types}",
            leftTitle: "${translate!.assets} ${translate!.types}",
            rightTitle: translate!.countries,
            rightvalue: "${assetsData.summary.countries}"),
        Visibility(
          visible: (assetsData.summary.total.amount != 0.0),
          child: AssetsLiabilityPieChart(assetsData.summary),
        ),
        const SizedBox(
          height: 20,
        ),
        MainAssetsWidget(
            name:
                "${translate!.cashAccounts} (${assetsData.bankAccounts.length})",
            icon: appIcons.assetsPaths!.cashAccount!.mainIcon!,
            // checking Disconnected Accounts Count if it is Zero Hide Warning Icon
            showDisconnected:
                assetsData.summary.bankAccounts.disconnectedAccountCount > 0,
            page: assetsData.bankAccounts.isEmpty
                ? AddBankAccountPage(
                    isAppBar: true,

                    successPopUp: (_, {required String source}) async {
                      if (_) {
                        // success
                        await RootApplicationAccess().storeAssets();
                        await RootApplicationAccess().storeLiabilities();
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: translate?.accountLinkedSuccessfully ?? '',
                            info: getPopUpDescription(source),
                            buttonLabel: translate?.continueWord ?? "",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {});
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          BankAccountMain()));
                            });
                        resetState();
                      } else {
                        // exited
                        Navigator.pop(context);
                      }
                    },
                    // manualAddButtonAction: AddBankManualPage(),
                    manualAddButtonAction: () async {
                      final data = await Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  assetsData.bankAccounts.isEmpty
                                      ? AddBankManualPage(
                                          isFromDashboard: true,
                                        )
                                      : BankAccountMain()));
                      if (data != null) {
                        cupertinoNavigator(
                            context: context,
                            screenName: BankAccountMain(),
                            type: NavigatorType.PUSH);

                        resetState();
                      }
                      resetState();
                    },
                    subtitle: translate!.selectBankSubtitle,
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.searchYourBank,

                    title: "${translate!.add} ${translate!.cashAccounts}",
                  )
                : BankAccountMain(),
            circleColor: assetsData.bankAccounts.isEmpty
                ? _emptyColor
                : assetColors.cashAccount!,
            total:
                " ${assetsData.summary.bankAccounts.currency} ${numberFormat.format(assetsData.summary.bankAccounts.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name: "${translate!.properties} (${assetsData.properties.length})",
            icon: "assets/icons/Property.png",
            page: assetsData.properties.isEmpty
                ? AddPropertyPage()
                : const PropertiesMainPage(),
            circleColor: assetsData.properties.isEmpty
                ? _emptyColor
                : assetColors.properties!,
            total:
                " ${assetsData.summary.properties.currency} ${numberFormat.format(assetsData.summary.properties.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name: "${translate!.vehicles} (${assetsData.vehicles.length})",
            icon: "assets/icons/Vehicle.png",
            page: assetsData.vehicles.isEmpty
                ? AddVehicleManualPage()
                : VehiclesMainPage(),
            circleColor: assetsData.vehicles.isEmpty
                ? _emptyColor
                : assetColors.vehicles!,
            total:
                " ${assetsData.summary.vehicles.currency} ${numberFormat.format(assetsData.summary.vehicles.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.investments} (${assetsData.investments.length})",
            icon: "assets/icons/Investments.png",
            // checking Disconnected Accounts Count if it is Zero Hide Warning Icon
            showDisconnected:
                assetsData.summary.investments.disconnectedAccountCount > 0,
            page: assetsData.investments.isEmpty
                ? AddBankAccountPage(
                    isAppBar: true,
                    successPopUp: (_, {required String source}) async {
                      if (_) {
                        // success
                        await RootApplicationAccess().storeAssets();
                        await RootApplicationAccess().storeLiabilities();
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: translate?.accountLinkedSuccessfully ?? "",
                            info: getPopUpDescription(source),
                            buttonLabel: translate?.continueWord ?? "",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {});
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          InvestmentsMainPage()));
                            });
                      } else {
                        // exited
                        Navigator.pop(context);
                      }
                    },
                    subtitle: translate!.orSelectFromTheBrokersBelow,
                    manualAddButtonAction: () async {
                      final data = await Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  AddInvestmentManualPage()));
                      resetState();
                    },
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.addInvestmentPlatforms,
                    title: translate!.addInvestmentPlatforms,
                  )
                : InvestmentsMainPage(),
            circleColor: assetsData.investments.isEmpty
                ? _emptyColor
                : assetColors.investment!,
            total:
                " ${assetsData.summary.investments.currency} ${numberFormat.format(assetsData.summary.investments.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name: "${translate!.pensions} (${assetsData.pensions.length})",
            icon: "assets/icons/Pension.png",
            // checking Disconnected Accounts Count if it is Zero Hide Warning Icon
            showDisconnected:
                assetsData.summary.pensions.disconnectedAccountCount > 0,
            page: assetsData.pensions.isEmpty
                ? AddBankAccountPage(
                    isAppBar: true,
                    successPopUp: (_, {required String source}) async {
                      if (_) {
                        // success
                        await RootApplicationAccess().storeAssets();
                        await RootApplicationAccess().storeLiabilities();
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: translate?.accountLinkedSuccessfully ?? "",
                            info: getPopUpDescription(source),
                            buttonLabel: translate?.continueWord ?? "",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {});
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (BuildContext context) =>
                                          PensionMainPage()));
                            });
                      } else {
                        // exited
                        Navigator.pop(context);
                      }
                    },
                    subtitle: translate!.orSelectFromthePensionProvidersBelow,
                    manualAddButtonAction: () async {
                      final data = await Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  AddPensionManualPage()));
                      resetState();
                    },
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.searchYourPensionProvider,
                    title: "${translate!.add} ${translate!.pensions}",
                  )
                : PensionMainPage(),
            circleColor: assetsData.pensions.isEmpty
                ? _emptyColor
                : assetColors.pensions!,
            total:
                " ${assetsData.summary.pensions.currency} ${numberFormat.format(assetsData.summary.pensions.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.cryptoCurrencies} (${assetsData.cryptoCurrencies.length})",
            icon: "assets/icons/Crypto.png",
            page: assetsData.cryptoCurrencies.isEmpty
                ? const AddCryptoManualPage()
                : const CryptoMainPage(),
            circleColor: assetsData.cryptoCurrencies.isEmpty
                ? _emptyColor
                : assetColors.crypto!,
            total:
                " ${assetsData.summary.cryptoCurrencies.currency} ${numberFormat.format(assetsData.summary.cryptoCurrencies.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.stocksBonds} (${assetsData.stocksBonds.length})",
            icon: "assets/icons/Bonds_light.png",
            page: assetsData.stocksBonds.isEmpty
                ? AddStocksPage()
                : StocksMainPage(),
            circleColor: assetsData.stocksBonds.isEmpty
                ? _emptyColor
                : assetColors.stocks!,
            total:
                " ${assetsData.summary.stocksBonds.currency} ${numberFormat.format(assetsData.summary.stocksBonds.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.customAssets} (${assetsData.otherAssets.length})",
            icon: "assets/icons/Assets.png",
            page: assetsData.otherAssets.isEmpty
                ? AddCustomAssetsPage()
                : const CustomAssetsMainPage(),
            circleColor: assetsData.otherAssets.isEmpty
                ? _emptyColor
                : assetColors.customAssets!,
            total:
                " ${assetsData.summary.otherAssets.currency} ${numberFormat.format(assetsData.summary.otherAssets.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
      ],
    );
  }

  Widget _liabilitiesList(AssetsLiabilitiesModel state) {
    var liabilitiesData = state.liabilities;
    LiabiltiesTheme liabiltiesTheme = appThemeColors!.charts!.liabilties!;
    return ListView(
      controller: _controller,
      children: [
        DashboardValueContainer(
            mainValue:
                "${liabilitiesData.summary.total.currency} ${liabilitiesData.summary.total.amount}",
            mainTitle: translate!.totalLiabilityValue,
            leftValue: "${liabilitiesData.summary.types}",
            leftTitle: "${translate!.liabilities} ${translate!.types}",
            rightTitle: translate!.countries,
            rightvalue: "${liabilitiesData.summary.countries}"),
        Visibility(
            visible: (liabilitiesData.summary.total.amount != 0.0),
            child: LiabilityPieChart(liabilitiesData.summary)),
        const SizedBox(
          height: 20,
        ),
        MainAssetsWidget(
            name:
                "${translate!.mortgages} (${liabilitiesData.mortgages.length})",
            icon: "assets/icons/Property.png",
            page: liabilitiesData.mortgages.isEmpty
                ? AddMortgagesPage(mortgages: [])
                : const MortgageMainPage(),
            circleColor: liabilitiesData.mortgages.isEmpty
                ? _emptyColor
                : liabiltiesTheme.mortgages!,
            total:
                " ${liabilitiesData.summary.mortgages.currency} ${numberFormat.format(liabilitiesData.summary.mortgages.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.creditCards} (${liabilitiesData.creditCards.length})",
            //Color(0xfffFFE07D),Color(0xfffF99664),Color(0xfff51AF86),Color(0xfffFF8686),Color(0xfff428DFF)
            icon: "assets/icons/card.png",
            showDisconnected:
                liabilitiesData.summary.creditCards.disconnectedAccountCount >
                    0,
            page: liabilitiesData.creditCards.isEmpty
                ? AddBankAccountPage(
                    isAppBar: true,
                    successPopUp: (_, {required String source}) async {
                      if (_) {
                        // success
                        await RootApplicationAccess().storeLiabilities();
                        await RootApplicationAccess().storeAssets();
                        locator.get<WedgeDialog>().success(
                            context: context,
                            title: translate?.accountLinkedSuccessfully ?? "",
                            info: getPopUpDescription(source),
                            buttonLabel: translate?.continueWord ?? "",
                            onClicked: () async {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              setState(() {});
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          CreditCardDebtMainPage()));
                            });
                      } else {
                        // exited
                        Navigator.pop(context);
                      }
                    },
                    subtitle: translate!.selectBankSubtitle,
                    manualAddButtonAction: () async {
                      final data = await Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  AddCreditCardDebtPage()));
                      if (data != null) {
                        setState(() {});
                      }
                    },
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.searchYourCreditCardProvider,
                    title: "${translate!.add} ${translate!.creditCards}",
                  )
                : CreditCardDebtMainPage(),
            circleColor: liabilitiesData.creditCards.isEmpty
                ? _emptyColor
                : liabiltiesTheme.creditCards!,
            total:
                " ${liabilitiesData.summary.creditCards.currency} ${numberFormat.format(liabilitiesData.summary.creditCards.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.vehicleLoans} (${liabilitiesData.vehicleLoans.length})",
            icon: "assets/icons/Vehicle.png",
            page: liabilitiesData.vehicleLoans.isEmpty
                ? AddVehicleLoanPage()
                : VehicleLoanMainPage(),
            circleColor: liabilitiesData.vehicleLoans.isEmpty
                ? _emptyColor
                : liabiltiesTheme.vehicleLoans!,
            total:
                " ${liabilitiesData.summary.vehicleLoans.currency} ${numberFormat.format(liabilitiesData.summary.vehicleLoans.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.personalLoans} (${liabilitiesData.personalLoans.length})",
            icon: "assets/icons/Bank.png",
            page: liabilitiesData.personalLoans.isEmpty
                ? AddPersonalLoanPage()
                : const PersonalLoanMainPage(),
            circleColor: liabilitiesData.personalLoans.isEmpty
                ? _emptyColor
                : liabiltiesTheme.personLoans!,
            total:
                " ${liabilitiesData.summary.personalLoans.currency} ${numberFormat.format(liabilitiesData.summary.personalLoans.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
        MainAssetsWidget(
            name:
                "${translate!.customLiabilities} (${liabilitiesData.otherLiabilities.length})",
            icon: "assets/icons/Liabilities.png",
            page: liabilitiesData.otherLiabilities.isEmpty
                ? AddOtherLiabilitiesPage()
                : OtherLiabilitiesMainPage(),
            circleColor: liabilitiesData.otherLiabilities.isEmpty
                ? _emptyColor
                : liabiltiesTheme.customLiabilities!,
            total:
                " ${liabilitiesData.summary.otherLiabilities.currency} ${numberFormat.format(liabilitiesData.summary.otherLiabilities.amount)}",
            onBack: () {
              resetState();
            }),
        verticalSpacing(),
      ],
    );
  }

  SizedBox verticalSpacing() {
    return const SizedBox(
      height: 10,
    );
  }
}
