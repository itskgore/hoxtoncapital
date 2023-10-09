import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/all_accounts_types/presentation/bloc/cubit/mainassetsliabilities_cubit.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/pages/add_crypto_manual_page.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/presentation/pages/add_custom_assets_page.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import 'package:wedge/features/assets/pension/add_pension_manual/presentation/pages/add_pension_manual_page.dart';
import 'package:wedge/features/assets/properties/add_properties/presentation/pages/add_property_page.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/presentation/pages/add_stocks_page.dart';
import 'package:wedge/features/assets/vehicle/add_vehicle/presentation/pages/add_vehicle_manual_page.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/pages/add_add_credit_card_debt_page.dart';
import 'package:wedge/features/liabilities/mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/presentation/pages/add_other_liabilities_page.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/presentation/pages/add_personal_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';

import '../../../../core/helpers/firebase_analytics.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../assets/assets_liablities_main/data/Models/assets_liabilities_model.dart';

class AllAccountTypes extends StatefulWidget {
  const AllAccountTypes({Key? key}) : super(key: key);

  @override
  State<AllAccountTypes> createState() => _AllAccountTypesState();
}

class _AllAccountTypesState extends State<AllAccountTypes> {
  @override
  void initState() {
    context.read<MainAssetsLiabilitiesCubit>().getData();
    AppAnalytics().trackEvent(
      eventName: "hoxton-onboarding-mobile",
      parameters: {
        "email Id": locator<SharedPreferences>()
                .getString(RootApplicationAccess.userEmailIDPreferences) ??
            locator<SharedPreferences>()
                .getString(RootApplicationAccess.emailUserPreferences) ??
            '',
        'firstName': getUserNameFromAccessToken()
      },
    );

    super.initState();
  }

  resetState() {
    setState(() {
      context.read<MainAssetsLiabilitiesCubit>().getData();
    });
  }

  List<bool> isSelected = [true, false];
  final _controller = ScrollController();

  bool isAssetAndLiabilityNotAdded =
      (RootApplicationAccess.assetsEntity?.summary.types == 0 ||
              RootApplicationAccess.assetsEntity?.summary.types == null) &&
          (RootApplicationAccess.liabilitiesEntity?.summary.types == 0 ||
              RootApplicationAccess.liabilitiesEntity?.summary.types == null);

  @override
  Widget build(BuildContext context) {
    double bottomSheetHeight = isAssetAndLiabilityNotAdded ? 0 : 100;

    return Scaffold(
      appBar: wedgeAppBar(context: context, title: 'Assets & Liabilities'),
      backgroundColor: appThemeColors!.bg,
      bottomSheet:
          BlocBuilder<MainAssetsLiabilitiesCubit, MainAssetsLiabilitiesState>(
        builder: (context, state) {
          if (state is MainAssetsLiabilitiesLoaded) {
            return Container(
                width: double.infinity,
                height: bottomSheetHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: appThemeColors!.primary!, width: 2),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    fixedSize: const Size(0, 60),
                  ),
                  onPressed: () {
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
                        screenName: const HomePage(),
                        type: NavigatorType.PUSHREMOVEUNTIL);
                  },
                  child: Text(
                    "View Dashboard",
                    style: TitleHelper.h10,
                  ),
                ));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
      body:
          BlocConsumer<MainAssetsLiabilitiesCubit, MainAssetsLiabilitiesState>(
        listener: (con, state) {
          if (state is MainAssetsLiabilitiesError) {
            showSnackBar(context: context, title: state.errorMsg);
          }
        },
        builder: (context, state) {
          if (state is MainAssetsLiabilitiesLoaded) {
            final assetTotal = numberFormat.format(
                state.assetsLiabilitiesData.assets.summary.total.amount);
            return Container(
              color: appThemeColors!.bg,
              child: Padding(
                padding: const EdgeInsets.all(kpadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PreferredSize(
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
                                              width:
                                                  constraints.maxWidth / 2.1),
                                          fillColor: appThemeColors!.primary,
                                          selectedColor:
                                              appThemeColors!.textLight,
                                          textStyle: SubtitleHelper.h11
                                              .copyWith(color: kfontColorDark),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                              child:
                                                  Center(child: Text(ASSETS)),
                                            ),
                                            Container(
                                                // width:
                                                // MediaQuery.of(context).size.width / 2,
                                                child: const Padding(
                                              padding: EdgeInsets.all(6.0),
                                              child: Center(
                                                  child: Text(LIABILITIES)),
                                            )),
                                          ]);
                                    },
                                  )),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: isSelected[0]
                          ? _assetList(state.assetsLiabilitiesData)
                          : _liabilitiesList(state.assetsLiabilitiesData),
                    )
                  ],
                ),
              ),
            );
          } else if (state is MainAssetsLiabilitiesError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Center(
              child: buildCircularProgressIndicator(width: 200),
            );
          }
        },
      ),
    );
  }

  Widget _assetList(AssetsLiabilitiesModel state) {
    log(size.height.toString(), name: 'height');
    return GridView.count(
      shrinkWrap: true,
      physics: isAssetAndLiabilityNotAdded && size.height > 800
          ? const NeverScrollableScrollPhysics()
          : null,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: [
        AssetCard(
          title: translate!.cashAccounts,
          image: 'assets/icons/Bank.png',
          navigateTo: AddBankManualPage(),
        ),
        AssetCard(
          title: translate!.properties,
          image: 'assets/icons/Property.png',
          navigateTo: AddPropertyPage(),
        ),
        AssetCard(
          title: translate!.vehicles,
          image: 'assets/icons/Vehicle.png',
          navigateTo: AddVehicleManualPage(),
        ),
        AssetCard(
          title: translate!.investments,
          image: 'assets/icons/Investments.png',
          navigateTo: AddInvestmentManualPage(),
        ),
        AssetCard(
          title: translate!.pensions,
          image: 'assets/icons/Pension.png',
          navigateTo: AddPensionManualPage(),
        ),
        AssetCard(
          title: translate!.cryptoCurrencies,
          image: 'assets/icons/Crypto.png',
          navigateTo: const AddCryptoManualPage(),
        ),
        AssetCard(
          title: translate!.stocksBonds,
          image: 'assets/icons/Bonds_light.png',
          navigateTo: AddStocksPage(),
        ),
        AssetCard(
          title: translate!.customAssets,
          image: 'assets/icons/Assets.png',
          navigateTo: AddCustomAssetsPage(),
        ),
        const SizedBox(),
      ],
    );
  }

  Widget _liabilitiesList(AssetsLiabilitiesModel state) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      children: [
        AssetCard(
          title: translate!.personalLoans,
          image: 'assets/icons/Bank.png',
          navigateTo: AddPersonalLoanPage(),
        ),
        AssetCard(
          title: translate!.mortgages,
          image: 'assets/icons/Property.png',
          navigateTo: AddMortgagesPage(
            mortgages: [],
          ),
        ),
        AssetCard(
          title: translate!.creditCards,
          image: 'assets/icons/card.png',
          navigateTo: AddCreditCardDebtPage(),
        ),
        AssetCard(
          title: translate!.vehicleLoans,
          image: 'assets/icons/Vehicle.png',
          navigateTo: AddVehicleLoanPage(),
        ),
        AssetCard(
          title: translate!.customLiabilities,
          image: 'assets/icons/Liabilities.png',
          navigateTo: AddOtherLiabilitiesPage(),
        ),
      ],
    );
  }
}

class AssetCard extends StatelessWidget {
  const AssetCard({
    Key? key,
    required this.image,
    required this.title,
    required this.navigateTo,
  }) : super(key: key);
  final String image;
  final String title;
  final Widget navigateTo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => navigateTo),
        );
      },
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50, color: Color(0xFFCFCFCF)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 10),
              Image.asset(
                image,
                color: appThemeColors!.primary,
                height: 35,
              ),
              Text(
                title,
                style: SubtitleHelper.h10,
              ),
            ],
          )),
    );
  }
}
