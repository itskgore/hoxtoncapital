import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/entities/liabilities_total_summary_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/liabilities/credit_card/add_credit_card_debt/presentation/pages/add_add_credit_card_debt_page.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/main_credit_card_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/contants/theme_contants.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../../../../../../core/widgets/bottomSheet/date_picker_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';
import '../../../../../../core/widgets/shimmer_container.dart';
import '../../../../../../core/widgets/wedge_expension_tile.dart';
import '../../../../../aggregator_reconnect/presentation/pages/aggregator_reconnect_icon.dart';
import '../../../../../assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import '../../../../../assets/pension_investment/pension_investments_main/presentation/widgets/list_tile_inverstments.dart';
import 'credit_card_account_summary.dart';

class CreditCardDebtMainPage extends StatefulWidget {
  const CreditCardDebtMainPage({Key? key}) : super(key: key);

  @override
  State<CreditCardDebtMainPage> createState() => _CreditCardDebtMainPageState();
}

class _CreditCardDebtMainPageState extends State<CreditCardDebtMainPage> {
  final lastDayPerformanceSummary = ValueNotifier<LastDayPerformance?>(null);
  final ValueNotifier<DateTime?> _currentMonth = ValueNotifier<DateTime?>(null);

  @override
  initState() {
    // get Chart Data
    context.read<LinePerformanceCubit>().getLinePerformanceData(
        merge: true,
        isFiltered: false,
        isPerformance: false,
        scope: ["fi"],
        fromDate: dateFormatter5
            .format(DateTime(DateTime.now().year, DateTime.now().month, 1)),
        toDate: dateFormatter5.format(
          DateTime(DateTime.now().year, DateTime.now().month + 1, -1),
        ),
        assetType: "creditCard");

    super.initState();
  }

  addCreditCard(List<CreditCardsEntity> creditCards) async {
    var data;
    if (creditCards.isEmpty) {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddBankAccountPage(
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
                    placeholder: translate!.searchYourCreditCardProvider,
                    title: "${translate!.add} ${translate!.creditCards}",
                  )));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddBankAccountPage(
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
                    placeholder: translate!.searchYourCreditCardProvider,
                    title: "${translate!.add} ${translate!.creditCards}",
                  )));
    }
    if (data != null) {
      if (!mounted) return;
      context.read<MainCreditCardCubit>().getCreditCards();
    }
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    Size size = MediaQuery.of(navigatorKey.currentState!.context).size;
    return WillPopScope(
      onWillPop: () async {
        // refreshMainState(context: context, isAsset: false);
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.creditCards,
            leadingIcon: getLeadingIcon(context, false),
            actions: IconButton(
                onPressed: () async {
                  addCreditCard(
                      RootApplicationAccess.liabilitiesEntity?.creditCards ??
                          []);
                },
                icon: const Icon(Icons.add))),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocConsumer<MainCreditCardCubit, MainCreditCardState>(
                bloc: context.read<MainCreditCardCubit>().getCreditCards(),
                listener: (context, state) {
                  if (state is MainCreditCardLoaded) {
                    if (state.showDeleteSnack) {
                      showSnackBar(
                          context: context, title: "Credit Card deleted!");
                      setState(() {
                        isDeleting = false;
                      });
                    }
                  }
                  if (state is MainCreditCardError) {
                    showSnackBar(context: context, title: state.errorMsg);
                    setState(() {
                      isDeleting = false;
                    });
                  }
                },
                builder: (context, state) {
                  if (state is MainCreditCardLoaded) {
                    LiabilitiesTotalEntity creditLoansSummary =
                        state.liabilitiesEntity.summary.creditCards;
                    List<CreditCardsEntity> creditCardEntity =
                        state.liabilitiesEntity.creditCards;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ValueListenableBuilder(
                          valueListenable: lastDayPerformanceSummary,
                          builder: (context, value, child) {
                            return DashboardValueContainer(
                                mainValue:
                                    "${creditLoansSummary.currency} ${creditLoansSummary.amount}",
                                mainTitle: translate!.totalOutstandingValue,
                                leftValue: "${creditCardEntity.length}",
                                leftTitle: creditCardEntity.length == 1
                                    ? translate!.creditCards
                                    : translate!.creditCards,
                                summary: value,
                                rightTitle: "Countries",
                                leftImage:
                                    "assets/icons/creditcardMainContainer.png",
                                rightvalue:
                                    "${creditLoansSummary.countryCount}");
                          },
                        ),
                        Center(
                          child: SizedBox(
                            width: size.width * .35,
                            child: ValueListenableBuilder(
                                valueListenable: _currentMonth,
                                builder: (context, currentMonthValue, child) {
                                  return DatePickerBottomSheet(
                                    onChange: (value) {
                                      if (_currentMonth.value != null) {
                                        _currentMonth.value = null;
                                      }
                                      log("value : $value");
                                      context
                                          .read<LinePerformanceCubit>()
                                          .getLinePerformanceData(
                                              merge: true,
                                              isFiltered: false,
                                              isPerformance: false,
                                              scope: ["fi"],
                                              fromDate: dateFormatter5.format(
                                                DateTime(
                                                    DateTime.parse(
                                                            value.toString())
                                                        .year,
                                                    DateTime.parse(
                                                            value.toString())
                                                        .month,
                                                    1),
                                              ),
                                              toDate: dateFormatter5.format(
                                                DateTime(
                                                    DateTime.parse(
                                                            value.toString())
                                                        .year,
                                                    DateTime.parse(value
                                                                .toString())
                                                            .month +
                                                        1,
                                                    -1),
                                              ),
                                              assetType: "creditCard");
                                      setState(() {});
                                    },
                                    initDate: DateTime.now(),
                                    showOneYearDateRange: true,
                                    selectedDate: currentMonthValue,
                                  );
                                }),
                          ),
                        ),
                        BlocConsumer<LinePerformanceCubit,
                            LinePerformanceState>(
                          listener: (context, state) {
                            if (state is LinePerformanceLoaded) {
                              lastDayPerformanceSummary.value = state
                                  .linePerformanceModel
                                  .merge
                                  ?.fi
                                  ?.lastDayPerformanceSummary;
                              // log("Listener called! Data: ${state.linePerformanceModel.merge?.fi?.lastDayPerformanceSummary?.diff}");
                            }
                          },
                          builder: (context, state) {
                            double graphHeight = size.height * .25;
                            if (state is LinePerformanceLoading) {
                              return CustomShimmerContainer(
                                  height: graphHeight);
                            } else if (state is LinePerformanceLoaded) {
                              return Column(
                                children: [
                                  state.data.isEmpty
                                      ? Container(
                                          height: graphHeight,
                                          alignment: Alignment.center,
                                          child: Text(
                                            translate!.noDataFound,
                                            style: SubtitleHelper.h10,
                                          ),
                                        )
                                      // TODO: @shubhro: putting sizedbox instead of container giving whitespace error after navigating back from summary screen. why?
                                      : Container(
                                          width: size.width,
                                          height: graphHeight,
                                          child: WedgeEcharts(
                                            showTransDate: true,
                                            isFiltered: state.isFiltered,
                                            currency: state.baseCurrency,
                                            data: state.data,
                                            index: 2,
                                          )),
                                  Visibility(
                                      visible: state.data.isNotEmpty,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 15),
                                        child: Text(
                                          translate!.outstandingBalance,
                                          style: TitleHelper.h12,
                                        ),
                                      ))
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
                                  "${translate!.account_label} (${creditCardEntity.length})",
                                  style: TitleHelper.h9),
                              AppButton(
                                  label: translate!.add,
                                  onTap: () async {
                                    addCreditCard(
                                        state.liabilitiesEntity.creditCards);
                                  }),
                            ],
                          ),
                        ),
                        Column(
                          children:
                              List.generate(creditCardEntity.length, (index) {
                            if (creditCardEntity[index].source.toLowerCase() ==
                                "manual") {
                              return _exptiles(
                                  data: creditCardEntity[index],
                                  totalAmt:
                                      creditLoansSummary.amount.toString(),
                                  index: index);
                            } else {
                              return _customListTile(
                                  data: creditCardEntity[index],
                                  totalAmt:
                                      creditLoansSummary.amount.toString(),
                                  index: index,
                                  onTab: () {
                                    creditCardEntity[index]
                                                .source
                                                .toLowerCase() !=
                                            "manual"
                                        ? Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    CreditCardAccountSummary(
                                                      cardData:
                                                          creditCardEntity[
                                                              index],
                                                    ))).then((value) {
                                            context
                                                .read<LinePerformanceCubit>()
                                                .getLinePerformanceData(
                                                    merge: true,
                                                    isFiltered: false,
                                                    isPerformance: false,
                                                    scope: ["fi"],
                                                    fromDate: dateFormatter5
                                                        .format(DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            1)),
                                                    toDate: dateFormatter5
                                                        .format(DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                    .month +
                                                                1,
                                                            -1)),
                                                    assetType: "creditCard");
                                            _currentMonth.value =
                                                DateTime.now();
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
                  } else if (state is MainCreditCardLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is MainCreditCardError) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              )),
        ),
        bottomNavigationBar: FooterButton(
          text: translate!.addOtherLiabilities,
          onTap: () {
            // refreshMainState(context: context, isAsset: false);
            Navigator.pop(context);
            // Navigator.push(
            //     context,
            //     CupertinoPageRoute(
            //         builder: (BuildContext context) => AddLiabilitiesPage()));
          },
        ),
      ),
    );
  }

  bool isDeleting = false;

  Widget _customListTile(
      {required CreditCardsEntity data,
      required String totalAmt,
      required int index,
      required Function() onTab}) {
    // final isProvider = data.source.toLowerCase() != "manual";

    return Stack(
      children: [
        ListTileInvestment(
          onTap: () {
            onTab();
          },
          source: data.source,
          saltedgeData: data,
          subTitle: data.name,
          leading: SvgPicture.network(
            height: 40,
            width: 40,
            data.aggregatorLogo,
            placeholderBuilder: (context) {
              return Image.asset(
                "assets/icons/persoanlLoanMainContainer.png",
                height: 40,
                width: 40,
              );
            },
            // Additional optional parameters
          ),
          title: data.providerName,
          trailing:
              '${data.outstandingAmount.currency} ${numberFormat1.format(data.outstandingAmount.amount)}',
        ),
        // Positioned(
        //   right: 42,
        //   top: 30,
        //   child: Visibility(
        //       visible: (isProvider),
        //       child: Image.asset("assets/icons/link_badge.png", height: 18)),
        // )
      ],
    );
  }

  Widget _exptiles(
      {required CreditCardsEntity data,
      required String totalAmt,
      required int index}) {
    final isProvider = data.source.toLowerCase() != "manual";

    return WedgeExpansionTile(
      isFromYodlee: data.source.toLowerCase() != "manual",
      margin: const EdgeInsets.only(bottom: 0, top: 18),
      padding: const EdgeInsets.symmetric(vertical: 6),
      borderRadius: 10,
      index: index,
      leading: SvgPicture.network(
        height: 40,
        width: 40,
        data.aggregatorLogo,
        placeholderBuilder: (context) {
          return Image.asset(
            "assets/icons/persoanlLoanMainContainer.png",
            height: 40,
            width: 40,
          );
        },
        // Additional optional parameters
      ),
      leftSubtitle: isProvider ? data.name : "",
      reconnectIcon: isAggregatorExpired(data: data)
          ? ReconnectIcon(
              isButton: true,
              data: data,
              onComplete: (val) {
                if (val) {
                  if (val) {
                    context.read<MainCreditCardCubit>().getCreditCards();
                  }
                }
              })
          : null,
      leftTitle: isProvider
          ? data.name.isEmpty
              ? data.providerName
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
                      subtitle: translate!.remeberMoreAccurateMessage,
                      acceptedPress: () {
                        showSnackBar(
                            context: context,
                            title: translate!.loading,
                            duration: const Duration(minutes: 3));

                        BlocProvider.of<MainCreditCardCubit>(context,
                                listen: false)
                            .deleteCreditCard(DeleteParams(id: data.id));
                        Navigator.pop(context);
                        setState(() {
                          isDeleting = true;
                        });
                      },
                      deniedPress: () {
                        Navigator.pop(context);
                      },
                      acceptText: translate!.yesDelete,
                      deniedText: translate!.noiWillKeepIt));
            },
      onEditPressed: data.source.toLowerCase() != "manual" || isDeleting
          ? null
          : () async {
              var result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => AddCreditCardDebtPage(
                            data: data,
                          )));
              if (result != null) {
                if (!mounted) return;
                context.read<MainCreditCardCubit>().getCreditCards();
                // }
              }
            },
      rightTitle:
          '${data.outstandingAmount.currency} ${numberFormat1.format(data.outstandingAmount.amount)}',
    );
  }
}
