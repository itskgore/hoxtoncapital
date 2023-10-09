import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/helpers/navigators.dart';

import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../dependency_injection.dart';
import '../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../assets/bank_account/add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import '../../../assets/bank_account/bank_accounts/presentation/bloc/cubit/home_bank_accounts_cubit.dart';
import '../../../assets/bank_account/main_bank_account/presentation/bloc/cubit/bank_accounts_cubit.dart';
import '../../../assets/bank_account/main_bank_account/presentation/pages/bank_account_main.dart';
import '../../../assets/bank_account/main_bank_account/presentation/pages/bank_account_summary.dart';
import 'sub_widgets/credit_card_widget.dart';
import 'sub_widgets/section_titlebar.dart';

class CashAccountCards extends StatefulWidget {
  DashboardDataEntity dashboardDataEntity;
  Function({bool? value}) onComplete;

  CashAccountCards(
      {Key? key, required this.dashboardDataEntity, required this.onComplete})
      : super(key: key);

  @override
  State<CashAccountCards> createState() => _CashAccountCardsState();
}

class _CashAccountCardsState extends State<CashAccountCards> {
  @override
  void initState() {
    context.read<BankAccountsCubit>().getData();
    super.initState();
  }

  getBankDetails({bool? isUpdated, bool? isInitialLoad}) {
    context.read<HomeBankAccountsCubit>().getData(
        transactionUpdated: isUpdated ?? false,
        isInitial: isInitialLoad ?? false);
  }

  addCashAccounts() {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (BuildContext context) => AddBankAccountPage(
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
                            getBankDetails();
                            widget.onComplete();
                            setState(() {});
                          });
                    } else {
                      // exited
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  subtitle: translate!.selectBankSubtitle,
                  manualAddButtonAction: () async {
                    cupertinoNavigator(
                        context: context,
                        screenName: AddBankManualPage(
                          isFromDashboard: true,
                          onComplete: () {
                            widget.onComplete();
                          },
                        ),
                        type: NavigatorType.PUSHREPLACE,
                        then: (_) {
                          setState(() {
                            getBankDetails();
                            Navigator.pop(context);
                            widget.onComplete();
                          });
                        });
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: "${translate!.add} ${translate!.cashAccounts}",
                  title: "${translate!.add} ${translate!.cashAccounts}",
                ))).then((value) async {
      widget.onComplete(value: true);
      getBankDetails();
      setState(() {});
    });
    widget.onComplete(value: true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitleBarHome(
            title: translate!.cashAccounts,
            onTap: () {
              Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => BankAccountMain()))
                  .then((value) {
                widget.onComplete();
              });
              ;
            }),
        const SizedBox(
          height: 10.0,
        ),
        widget.dashboardDataEntity.data.bankAccounts.details.isEmpty
            ? Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/placeholders/card_placeholder.svg",
                        height: 61,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "No data available",
                          style: TitleHelper.h11,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          "Please link your cash account or add data manually.",
                          style: SubtitleHelper.h12,
                        ),
                      ),
                      FittedBox(
                        child: AppButton(
                          label: "Add Accounts",
                          style: TitleHelper.h12.copyWith(color: Colors.white),
                          borderRadius: 4,
                          verticalPadding: 8,
                          onTap: () {
                            addCashAccounts();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : widget.dashboardDataEntity.data.bankAccounts.linkedAccounts == 0
                ? Container()
                : SizedBox(
                    height: 215,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.dashboardDataEntity.data.bankAccounts
                            .linkedAccounts,
                        itemBuilder: (BuildContext context, int index) {
                          List<DetailsEntity> data = widget
                              .dashboardDataEntity.data.bankAccounts.details;
                          bool isManual =
                              data[index].source.toLowerCase() == "manual";
                          return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: CreditCardWidget(
                                index: index,
                                isManual: isManual,
                                source: data[index].source,
                                aggregatorData: isManual ? null : data[index],
                                onTap: isManual
                                    ? null
                                    : () {
                                        cupertinoNavigator(
                                          context: context,
                                          screenName: BankAccountSummary(
                                            accountID: data[index].id,
                                          ),
                                          type: NavigatorType.PUSH,
                                          then: (value) {
                                            widget.onComplete();
                                          },
                                        );
                                      },
                                date: "",
                                country: data[index].country,
                                accountNumber: data[index].accountNumber,
                                bankName: data[index].name,
                                image: data[index].bankLogo,
                                isYodlee: data[index].source.toLowerCase() !=
                                    "manual",
                                amount:
                                    "${widget.dashboardDataEntity.data.baseCurrency} ${data[index].balance}",
                                backgroundColor:
                                    appThemeColors!.creditCards![index % 4],
                              ));
                        })),
        const SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}
