import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/src/intl/number_format.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_circular_progress_indicator.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/skip_home_widget.dart';
import 'package:wedge/features/assets/assets_widget.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/presentation/bloc/add_liabilities_page_cubit.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/pages/add_add_credit_card_debt_page.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/pages/credit_card_debt_main_page.dart';
import 'package:wedge/features/liabilities/mortgages/mortgages_main/presentation/pages/mortgage_main_page.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/presentation/pages/other_liabilities_main_page.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/presentation/pages/personal_loan_main_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/add_vehicle_loan/presentation/pages/add_vehicle_loan_page.dart';
import 'package:wedge/features/liabilities/vehicle_loan/vehicle_loan_main/presentation/pages/vehicle_loan_main_page.dart';

import '../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../dependency_injection.dart';
import '../../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../mortgages/add_mortgages/presentation/pages/add_mortgages_page.dart';
import '../../../other_liabilities/add_other_liabilities/presentation/pages/add_other_liabilities_page.dart';
import '../../../personal_loan/add_personal_loan/presentation/pages/add_personal_loan_page.dart';

class AddLiabilitiesPage extends StatefulWidget {
  // AddLiabilitiesPage({Key key}) : super(key: key);

  @override
  _AddLiabilitiesPageState createState() => _AddLiabilitiesPageState();
}

class _AddLiabilitiesPageState extends State<AddLiabilitiesPage> {
  NumberFormat numberFormat = NumberFormat("#,###,###.##", "en_US");

  Future<void> resetState() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context,
          title: "${translate!.add} ${translate!.liabilities}"),
      body: RefreshIndicator(
        onRefresh: () async {
          resetState();
        },
        child: BlocBuilder<AddLiabilitiesPageCubit, AddLiabilitiesPageState>(
          bloc: context.read<AddLiabilitiesPageCubit>().getMainLiabilities(),
          builder: (context, state) {
            if (state is AddLiabilitiesPageLoaded) {
              return Padding(
                padding: const EdgeInsets.all(kpadding),
                child: ListView(
                  children: [
                    DashboardValueContainer(
                        mainValue:
                            "${state.liabilitiesEntity.summary.total.currency} ${state.liabilitiesEntity.summary.total.amount}",
                        mainTitle: translate!.totalLiabilityValue,
                        leftValue: "${state.liabilitiesEntity.summary.types}",
                        leftTitle:
                            "${translate!.liabilities} ${translate!.types}",
                        rightTitle: translate!.countries,
                        leftImage: "assets/icons/mainLiabilitiesIcon.png",
                        rightvalue:
                            "${state.liabilitiesEntity.summary.countries}"),
                    AssetsWidget(
                        name:
                            "${translate!.personalLoans} (${state.liabilitiesEntity.personalLoans.length})",
                        icon: "assets/icons/Bank.png",
                        page: state.liabilitiesEntity.personalLoans.isEmpty
                            ? AddPersonalLoanPage()
                            : const PersonalLoanMainPage(),
                        total:
                            "${state.liabilitiesEntity.summary.personalLoans.currency} ${state.liabilitiesEntity.summary.personalLoans.amount}",
                        onBack: () {
                          setState(() {});
                        }),
                    AssetsWidget(
                        name:
                            "${translate!.creditCards} (${state.liabilitiesEntity.creditCards.length})",
                        icon: "assets/icons/card.png",
                        page: state.liabilitiesEntity.creditCards.isEmpty
                            ? AddBankAccountPage(
                                isAppBar: true,
                                successPopUp: (_,
                                    {required String source}) async {
                                  if (_) {
                                    // success
                                    await RootApplicationAccess()
                                        .storeLiabilities();
                                    locator.get<WedgeDialog>().success(
                                        context: context,
                                        title: translate
                                                ?.accountLinkedSuccessfully ??
                                            "",
                                        info: getPopUpDescription(source),
                                        buttonLabel:
                                            translate?.continueWord ?? "",
                                        onClicked: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          setState(() {});
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
                                placeholder:
                                    translate!.searchYourCreditCardProvider,
                                title:
                                    "${translate!.add} ${translate!.creditCards}",
                              )
                            : CreditCardDebtMainPage(),
                        total:
                            "${state.liabilitiesEntity.summary.creditCards.currency} ${state.liabilitiesEntity.summary.creditCards.amount}",
                        onBack: () {
                          resetState();
                        }),
                    AssetsWidget(
                        name:
                            "${translate!.mortgages} (${state.liabilitiesEntity.mortgages.length})",
                        icon: "assets/icons/Property.png",
                        page: state.liabilitiesEntity.mortgages.isEmpty
                            ? AddMortgagesPage(mortgages: [])
                            : const MortgageMainPage(),
                        total:
                            "${state.liabilitiesEntity.summary.mortgages.currency} ${state.liabilitiesEntity.summary.mortgages.amount}",
                        onBack: () {
                          setState(() {});
                        }),
                    AssetsWidget(
                        name:
                            "${translate!.vehicleLoans} (${state.liabilitiesEntity.vehicleLoans.length})",
                        icon: "assets/icons/Vehicle.png",
                        page: state.liabilitiesEntity.vehicleLoans.isEmpty
                            ? AddVehicleLoanPage()
                            : VehicleLoanMainPage(),
                        total:
                            "${state.liabilitiesEntity.summary.vehicleLoans.currency} ${state.liabilitiesEntity.summary.vehicleLoans.amount}",
                        onBack: () {
                          setState(() {});
                        }),
                    AssetsWidget(
                        name:
                            "${translate!.customLiabilities} (${state.liabilitiesEntity.otherLiabilities.length})",
                        icon: "assets/icons/Liabilities.png",
                        page: state.liabilitiesEntity.otherLiabilities.isEmpty
                            ? AddOtherLiabilitiesPage()
                            : OtherLiabilitiesMainPage(),
                        total:
                            "${state.liabilitiesEntity.summary.otherLiabilities.currency} ${state.liabilitiesEntity.summary.otherLiabilities.amount}",
                        onBack: () {
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    // Spacer(),
                    const SkipToHome(),
                  ],
                ),
              );
            } else if (state is AddLiabilitiesPageLoading) {
              return Center(
                child: buildCircularProgressIndicator(width: 200),
              );
            } else if (state is AddLiabilitiesPageError) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
