import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/entities/asset_total_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/bloc/cubit/cash_account_bar_performance_state.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/presentation/widgets/cash_account_bar_charts.dart';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/contants/theme_contants.dart';
import '../../../../../../core/entities/assets_entity.dart';
import '../../../../../../core/entities/manual_bank_accounts_entity.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';
import '../../../../../../core/widgets/shimmer_container.dart';
import '../../../../../../core/widgets/wedge_expension_tile.dart';
import '../../../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../../../assets/pension_investment/pension_investments_main/presentation/widgets/list_tile_inverstments.dart';
import '../../../add_bank_manual/presentation/pages/add_bank_manual_page.dart';
import '../bloc/cubit/bank_accounts_cubit.dart';
import '../bloc/cubit/cash_account_bar_performance_cubit.dart';
import 'bank_account_summary.dart';

class BankAccountMain extends StatefulWidget {
  final AssetsEntity? assetsEntity;
  final Widget? showSkip;

  const BankAccountMain({Key? key, this.showSkip, this.assetsEntity})
      : super(key: key);

  @override
  State<BankAccountMain> createState() => _BankAccountMainState();
}

class _BankAccountMainState extends State<BankAccountMain> {
  // AppLocalizations? translate;
  final lastDayPerformanceSummary = ValueNotifier<LastDayPerformance?>(null);

  @override
  initState() {
    context
        .read<CashAccountBarPerformanceCubit>()
        .getCashAccountBarPerformanceData();
    // TODO: @shubhro: commented because this implementation is under discussion.
    // context.read<LinePerformanceCubit>().getLinePerformanceData(
    //     merge: true,
    //     isPerformance: false,
    //     isFiltered: false,
    //     scope: ["fi"],
    //     fromDate: dateFormatter5.format(DateTime(
    //         DateTime.now().year, DateTime.now().month - 1, DateTime.now().day)),
    //     toDate: dateFormatter5.format(DateTime.now()),
    //     assetType: "bankAccount");
    super.initState();
  }

  addCashAccounts(List<ManualBankAccountsEntity> banks) async {
    dynamic data;
    if (banks.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddBankAccountPage(
                    isAppBar: true,
                    successPopUp: (_, {required String source}) async {
                      if (_) {
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
                                  AddBankManualPage()));
                      if (data != null && mounted) {
                        setState(() {});
                      }
                    },
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.searchYourBank,
                    title: "${translate!.add} ${translate!.cashAccounts}",
                  )));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddBankAccountPage(
                    isAppBar: true,
                    successPopUp: (_, {required String source}) async {
                      if (_) {
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
                                  AddBankManualPage()));
                      if (data != null) {
                        setState(() {});
                      }
                    },
                    manualAddButtonTitle: translate!.addManually,
                    placeholder: translate!.searchYourBank,
                    title: "${translate!.add} ${translate!.cashAccounts}",
                  )));
    }
    if (data != null) {
      if (mounted) {
        context.read<BankAccountsCubit>().getData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String? creditCurrency;
    return WillPopScope(
      onWillPop: () async {
        if (widget.showSkip != null) {
          return false;
        } else {
          return true;
        }
      },
      child: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          backgroundColor: appThemeColors!.bg,
          appBar: wedgeAppBar(
              context: context,
              title: translate!.cashAccounts,
              leadingIcon: getLeadingIcon(context, false),
              actions: IconButton(
                  onPressed: () async {
                    addCashAccounts(
                        RootApplicationAccess.assetsEntity?.bankAccounts ?? []);
                  },
                  icon: const Icon(Icons.add))),
          bottomNavigationBar: FooterButton(
            text: widget.showSkip == null
                ? translate!.addOtherAssets
                : translate!.next,
            onTap: () async {
              if (widget.showSkip != null) {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => widget.showSkip!),
                    (Route<dynamic> route) => false);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: BlocConsumer<BankAccountsCubit, BankAccountsState>(
                  bloc: context.read<BankAccountsCubit>().getData(),
                  listener: (context, state) {
                    if (state is BankAccountsLoaded) {
                      if (state.deleteMessageSent) {
                        showSnackBar(
                            context: context,
                            title:
                                "${translate!.bankAccount} ${translate!.removed}");
                        setState(() {
                          isDeleting = false;
                        });
                      }
                    } else if (state is BankAccountsError) {
                      showSnackBar(context: context, title: state.errorMsg);
                      setState(() {
                        isDeleting = false;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is BankAccountsLoaded) {
                      AssetTotalEntity creditLoansSummary =
                          state.assets.summary.bankAccounts;
                      creditCurrency = creditLoansSummary.currency;
                      List<ManualBankAccountsEntity> bankAccountEntityEntity =
                          state.assets.bankAccounts;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DashboardValueContainer(
                            mainValue:
                                "${creditLoansSummary.currency} ${creditLoansSummary.amount}",
                            mainTitle: translate!.totalCashBalance,
                            leftValue: "${state.assets.bankAccounts.length}",
                            leftTitle: translate!.cashAccounts,
                            leftImage:
                                "assets/icons/bankAccountMainContainer.png",
                            rightTitle: translate!.countries,
                            rightvalue:
                                "${state.assets.summary.bankAccounts.countryCount}",
                          ),

                          // TODO: @shubhro: commented because this implementation is under discussion.

                          // BlocListener<LinePerformanceCubit,
                          //     LinePerformanceState>(
                          //   listener: (context, state) {
                          //     if (state is LinePerformanceLoaded) {
                          //       lastDayPerformanceSummary.value = state
                          //           .linePerformanceModel
                          //           .merge
                          //           ?.fi
                          //           ?.lastDayPerformanceSummary;
                          //       log('cash account listener: ${lastDayPerformanceSummary.value?.diff}');
                          //     }
                          //   },
                          //   child: ValueListenableBuilder(
                          //       valueListenable: lastDayPerformanceSummary,
                          //       builder: (context, value, child) {
                          //         return DashboardValueContainer(
                          //           mainValue:
                          //               "${creditLoansSummary.currency} ${creditLoansSummary.amount}",
                          //           mainTitle: translate!.totalCashBalance,
                          //           leftValue:
                          //               "${state.assets.bankAccounts.length}",
                          //           leftTitle: translate!.cashAccounts,
                          //           leftImage:
                          //               "assets/icons/bankAccountMainContainer.png",
                          //           rightTitle: translate!.countries,
                          //           rightvalue:
                          //               "${state.assets.summary.bankAccounts.countryCount}",
                          //           summary: value,
                          //         );
                          //       }),
                          // ),
                          BlocBuilder<CashAccountBarPerformanceCubit,
                              CashAccountBarPerformanceState>(
                            builder: (context, state) {
                              double graphHeight = size.height * .3;
                              if (state is CashAccountBarPerformanceLoading) {
                                return CustomShimmerContainer(
                                    height: graphHeight);
                              } else if (state
                                  is CashAccountBarPerformanceLoaded) {
                                var dataList =
                                    state.cashAccountBarPerformanceList;
                                return dataList.isEmpty
                                    ? Container(
                                        height: graphHeight,
                                        alignment: Alignment.center,
                                        child: Text(
                                          translate!.noDataFound,
                                          style: SubtitleHelper.h10,
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: graphHeight,
                                            child: CashAccountBarChart(
                                              currency: getCurrency(),
                                              data: dataList,
                                            ),
                                          ),
                                          Text(
                                            translate!.cumulativeCashFlow,
                                            style: TitleHelper.h11,
                                          ),
                                          graphSubtitleTile(
                                              leading:
                                                  "assets/icons/down_arrow.png",
                                              title: translate!.inFlow,
                                              value: dataList.length > 2
                                                  ? "$creditCurrency ${numberFormat1.format(num.parse(dataList.last[1].toStringAsFixed(2)))}"
                                                  : "0.0"),
                                          const SizedBox(height: 10),
                                          graphSubtitleTile(
                                              leading:
                                                  "assets/icons/up_arrow.png",
                                              title: translate!.outFlow,
                                              value: dataList.length > 2
                                                  ? "$creditCurrency ${numberFormat1.format(num.parse(dataList.last[2].toStringAsFixed(2)))}"
                                                  : "0.0"),
                                        ],
                                      );
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "${translate!.account_label} (${bankAccountEntityEntity.length})",
                                    style: TitleHelper.h9),
                                AppButton(
                                    label: translate!.add,
                                    onTap: () async {
                                      addCashAccounts(
                                          state.assets.bankAccounts);
                                    }),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(
                                bankAccountEntityEntity.length, (index) {
                              if (bankAccountEntityEntity[index]
                                      .source!
                                      .toLowerCase() ==
                                  "manual") {
                                return _exptiles(
                                    data: bankAccountEntityEntity[index],
                                    totalAmt:
                                        creditLoansSummary.amount.toString(),
                                    index: index);
                              } else {
                                return _customListTile(
                                    data: bankAccountEntityEntity[index],
                                    totalAmt:
                                        creditLoansSummary.amount.toString(),
                                    index: index,
                                    onTab: () {
                                      bankAccountEntityEntity[index]
                                                  .source!
                                                  .toLowerCase() !=
                                              "manual"
                                          ? Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      BankAccountSummary(
                                                        accountData:
                                                            bankAccountEntityEntity[
                                                                index],
                                                        accountID:
                                                            bankAccountEntityEntity[
                                                                    index]
                                                                .id,
                                                      ))).then((value) {
                                              // TODO: @shubhro: can't find the use of this call. Should ask @Shahbaz.
                                              context
                                                  .read<LinePerformanceCubit>()
                                                  .getLinePerformanceData(
                                                      merge: true,
                                                      isPerformance: false,
                                                      isFiltered: false,
                                                      scope: ["fi"],
                                                      fromDate: dateFormatter5
                                                          .format(DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                  .month,
                                                              1)),
                                                      toDate: dateFormatter5
                                                          .format(DateTime(
                                                              DateTime.now()
                                                                  .year,
                                                              DateTime.now()
                                                                      .month +
                                                                  1,
                                                              -1)),
                                                      assetType: "bankAccount");
                                            })
                                          : null;
                                    });
                              }
                            }),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                    } else if (state is BankAccountsLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is BankAccountsError) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  Row graphSubtitleTile(
      {required String leading, required String title, String? value}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Image.asset(leading, height: 12),
        ),
        Text("$title : "),
        const Spacer(),
        Text(
          "$value",
          style: TitleHelper.h11,
        )
      ],
    );
  }

  bool isDeleting = false;

  Widget _customListTile(
      {required ManualBankAccountsEntity data,
      required String totalAmt,
      required int index,
      required Function() onTab}) {
    // final isProvider = data.source?.toLowerCase() != "manual";

    return Stack(
      children: [
        ListTileInvestment(
          title: data.providerName,
          subTitle: data.name,
          saltedgeData: data,
          trailing:
              '${data.currentAmount.currency} ${numberFormat1.format(data.currentAmount.amount)}',
          onTap: () {
            onTab();
          },
          source: data.source,
          leading: SvgPicture.network(
            height: 40,
            width: 40,
            data.aggregatorLogo!,
            placeholderBuilder: (context) {
              return Image.asset(
                "assets/icons/persoanlLoanMainContainer.png",
                height: 40,
                width: 40,
              );
            },
            // Additional optional parameters
          ),
        ),
        // Positioned(
        //   right: 42,
        //   top: 30,
        //   child: Visibility(
        //       visible: isProvider,
        //       child: Image.asset("assets/icons/link_badge.png", height: 18)),
        // )
      ],
    );
  }

  Widget _exptiles(
      {required ManualBankAccountsEntity data,
      required String totalAmt,
      required int index}) {
    final isProvider = data.source?.toLowerCase() != "manual";

    return WedgeExpansionTile(
      isFromYodlee: data.source?.toLowerCase() != "manual",
      margin: const EdgeInsets.only(bottom: 0, top: 18),
      padding: const EdgeInsets.symmetric(vertical: 6),
      borderRadius: 10,
      index: index,
      leading: Image.asset(
        "assets/icons/persoanlLoanMainContainer.png",
        height: 40,
        width: 40,
      ),
      leftSubtitle: isProvider ? data.name : "",
      // reconnectIcon: isAggregatorExpired(data)
      //     ? ReconnectIcon(
      //         isButton: true,
      //         data: data,
      //         onComplete: (val) {
      //           if (val) {
      //             if (val) {
      //               context.read<BankAccountsCubit>().getBankAccounts;
      //             }
      //           }
      //         })
      //     : null,
      leftTitle: isProvider
          ? data.name.isEmpty
              ? data.providerName!
              : data.name
          : data.name,
      midWidget: null,
      onDeletePressed: isDeleting
          ? null
          : () {
              locator.get<WedgeDialog>().confirm(
                  context,
                  WedgeConfirmDialog(
                    title: translate!.areYouSure,
                    subtitle: data.source?.toLowerCase() == "saltedge"
                        ? "All accounts related to this institution will be removed."
                        : "Your account information contributes a lot to showcasing your net worth information and other financial insights",
                    acceptText: translate!.yesDelete,
                    acceptedPress: () {
                      showSnackBar(
                          context: context,
                          title: translate!.loading,
                          duration: const Duration(minutes: 3));
                      setState(() {
                        isDeleting = true;
                      });
                      context
                          .read<BankAccountsCubit>()
                          .deleteBankAccount(data.id);
                      Navigator.pop(context);
                    },
                    deniedText: translate!.noiWillKeepIt,
                    deniedPress: () {
                      Navigator.pop(context);
                    },
                  ));
            },
      onEditPressed: data.source!.toLowerCase() != "manual" || isDeleting
          ? null
          : () async {
              var result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddBankManualPage(
                            manualBankData: data,
                          )));
              if (result != null) {
                if (!mounted) return;
                context.read<BankAccountsCubit>().getData();
              }
            },
      rightTitle:
          '${data.currentAmount.currency} ${numberFormat1.format(data.currentAmount.amount)}',
    );
  }
}
