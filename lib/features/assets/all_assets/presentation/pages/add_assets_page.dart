import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/skip_home_widget.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/all_assets/presentation/bloc/cubit/allassets_cubit.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/pages/crypto_main_page.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/pages/add_custom_assets_page.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/presentation/pages/custom_assets_main_page.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/pages/add_investment_main_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/pension/pension_main/presentation/pages/pension_main_page.dart';
import 'package:wedge/features/assets/properties/properties_main/presentation/pages/properties_main_page.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/pages/add_stocks_main_page.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/assets/vehicle/vehicle_main/presentation/pages/vehicles_main_page.dart';

import '../../../../../core/common/functions/common_functions.dart';
import '../../../assets_widget.dart';
import '../../../bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import '../../../crypto/add_crypto_manual/presentation/pages/add_crypto_manual_page.dart';
import '../../../properties/add_properties/presentation/pages/add_property_page.dart';
import '../../../stocks/add_stcoks/presentation/pages/add_stocks_page.dart';

class AddAssetsPage extends StatefulWidget {
  @override
  _AddAssetsPageState createState() => _AddAssetsPageState();
}

// ignore: non_constant_identifier_names

class _AddAssetsPageState extends State<AddAssetsPage> {
  NumberFormat numberFormat = NumberFormat("#,###,###.##", "en_US");
  final _controller = ScrollController();

  Future<void> resetState() async {
    setState(() {});
    _controller.jumpTo(0); //scroll up to the top
  }

  @override
  Widget build(BuildContext context) {
    var translate = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context, title: "${translate!.add} ${translate.assets}"),
      body: RefreshIndicator(
        onRefresh: () async {
          resetState();
        },
        child: BlocBuilder<AllAssetsCubit, AllAssetsState>(
          bloc: context.read<AllAssetsCubit>().getData(),
          builder: (context, state) {
            if (state is AllAssetsLoaded) {
              return Padding(
                padding: const EdgeInsets.all(kpadding),
                child: ListView(
                  controller: _controller,
                  children: [
                    DashboardValueContainer(
                        mainValue:
                            "${state.data.summary.total.currency} ${state.data.summary.total.amount}",
                        mainTitle: translate.totalAssetValue,
                        leftValue: "${state.data.summary.types}",
                        leftTitle: "${translate.assets} ${translate.types}",
                        rightTitle: translate.countries,
                        rightvalue: "${state.data.summary.countries}"),
                    AssetsWidget(
                        name:
                            "${translate.cashAccounts} (${state.data.bankAccounts.length})",
                        icon: "assets/icons/Bank.png",
                        page: state.data.bankAccounts.isEmpty
                            ? AddBankAccountPage(
                                isAppBar: true,
                                successPopUp: (_,
                                    {required String source}) async {
                                  if (_) {
                                    // success
                                    await RootApplicationAccess().storeAssets();
                                    await RootApplicationAccess()
                                        .storeLiabilities();
                                    locator.get<WedgeDialog>().success(
                                        context: context,
                                        title:
                                            translate.cashAccountMessageTitle,
                                        info: getPopUpDescription(source),
                                        buttonLabel: translate!.continueWord,
                                        onClicked: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {});

                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          BankAccountMain()));
                                        });
                                  } else {
                                    // exited
                                    Navigator.pop(context);
                                  }
                                },
                                subtitle: translate.selectBankSubtitle,
                                manualAddButtonAction: () async {
                                  final data = await Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              AddBankManualPage()));
                                  resetState();
                                },
                                manualAddButtonTitle: translate.addManually,
                                placeholder: translate.searchYourBank,
                                title:
                                    "${translate.add} ${translate.cashAccounts}",
                              )
                            : BankAccountMain(),
                        total:
                            "${state.data.summary.bankAccounts.currency} ${state.data.summary.bankAccounts.amount}",
                        onBack: () {
                          resetState();
                        }),

                    AssetsWidget(
                        name:
                            "${translate.properties} (${state.data.properties.length})",
                        icon: "assets/icons/Property.png",
                        page: state.data.properties.isEmpty
                            ? AddPropertyPage()
                            : const PropertiesMainPage(),
                        total:
                            "${state.data.summary.properties.currency} ${state.data.summary.properties.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name: "$VEHICLES (${state.data.vehicles.length})",
                        icon: "assets/icons/Vehicle.png",
                        page: state.data.vehicles.isEmpty
                            ? AddVehicleManualPage()
                            : VehiclesMainPage(),
                        total:
                            "${state.data.summary.vehicles.currency} ${state.data.summary.vehicles.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name:
                            "${translate.investments} (${state.data.investments.length})",
                        icon: "assets/icons/Investments.png",
                        page: state.data.investments.isEmpty
                            ? AddBankAccountPage(
                                isAppBar: true,
                                successPopUp: (_,
                                    {required String source}) async {
                                  if (_) {
                                    // success
                                    await RootApplicationAccess().storeAssets();
                                    await RootApplicationAccess()
                                        .storeLiabilities();
                                    locator.get<WedgeDialog>().success(
                                        context: context,
                                        title:
                                            translate.accountLinkedSuccessfully,
                                        info: getPopUpDescription(source),
                                        buttonLabel: translate.continueWord,
                                        onClicked: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
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
                                subtitle: translate.orSelectFromTheBrokersBelow,
                                manualAddButtonAction: () async {
                                  final data = await Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              AddInvestmentManualPage()));
                                  resetState();
                                },
                                manualAddButtonTitle: translate.addManually,
                                placeholder: translate.addInvestmentPlatforms,
                                title: translate.addInvestmentPlatforms,
                              )
                            : InvestmentsMainPage(),
                        total:
                            "${state.data.summary.investments.currency} ${state.data.summary.investments.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name:
                            "${translate.pensions} (${state.data.pensions.length})",
                        icon: "assets/icons/Pension.png",
                        page: state.data.pensions.isEmpty
                            ? AddBankAccountPage(
                                isAppBar: true,
                                successPopUp: (_,
                                    {required String source}) async {
                                  if (_) {
                                    // success
                                    await RootApplicationAccess().storeAssets();
                                    await RootApplicationAccess()
                                        .storeLiabilities();
                                    locator.get<WedgeDialog>().success(
                                        context: context,
                                        title: translate!
                                            .accountLinkedSuccessfully,
                                        info: getPopUpDescription(source),
                                        buttonLabel: translate!.continueWord,
                                        onClicked: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {});
                                          cupertinoNavigator(
                                              context: context,
                                              screenName: PensionMainPage(),
                                              type: NavigatorType.PUSH);
                                        });
                                  } else {
                                    // exited
                                    Navigator.pop(context);
                                  }
                                },
                                subtitle: translate
                                    .orSelectFromthePensionProvidersBelow,
                                manualAddButtonAction: () async {
                                  await Navigator.pushReplacement(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              AddPensionManualPage()));
                                  resetState();
                                },
                                manualAddButtonTitle: translate.addManually,
                                placeholder:
                                    translate.searchYourPensionProvider,
                                title: "${translate.add} ${translate.pensions}",
                              )
                            : PensionMainPage(),
                        total:
                            "${state.data.summary.pensions.currency} ${state.data.summary.pensions.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name:
                            "${translate.cryptoCurrencies} (${state.data.cryptoCurrencies.length})",
                        icon: "assets/icons/Crypto.png",
                        page: state.data.cryptoCurrencies.isEmpty
                            ? const AddCryptoManualPage()
                            : const CryptoMainPage(),
                        total:
                            "${state.data.summary.cryptoCurrencies.currency} ${state.data.summary.cryptoCurrencies.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name:
                            "${translate.stocksBonds} (${state.data.stocksBonds.length})",
                        icon: "assets/icons/Bonds_light.png",
                        page: state.data.stocksBonds.isEmpty
                            ? AddStocksPage()
                            : StocksMainPage(),
                        total:
                            "${state.data.summary.stocksBonds.currency} ${state.data.summary.stocksBonds.amount}",
                        onBack: () {
                          resetState();
                        }),

                    AssetsWidget(
                        name:
                            "${translate.customAssets} (${state.data.otherAssets.length})",
                        icon: "assets/icons/Assets.png",
                        page: state.data.otherAssets.isEmpty
                            ? AddCustomAssetsPage()
                            : const CustomAssetsMainPage(),
                        total:
                            "${state.data.summary.otherAssets.currency} ${state.data.summary.otherAssets.amount}",
                        onBack: () {
                          resetState();
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    // Spacer(),
                    const SkipToHome(),
                  ],
                ),
              );
            } else if (state is AllAssetsError) {
              return Center(child: Text(state.errorMsg));
            } else if (state is AllAssetsLoading) {
              return Center(child: buildCircularProgressIndicator(width: 200));
            } else {
              return Center(child: Text(translate.commonErrorMessage));
            }
          },
        ),
      ),
    );
  }
}
