import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/custom_assets_showcase.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/config/app_config.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/contants/string_contants.dart';
import '../../../../../../core/entities/manual_bank_accounts_entity.dart';
import '../../../../../../core/utils/reconnect_aggregator.dart';
import '../../../../../../core/utils/wedge_app_bar.dart';
import '../../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../../core/utils/wedge_func_methods.dart';
import '../../../../../../core/utils/wedge_snackBar.dart';
import '../../../../../../core/widgets/assets_menu_popup_item.dart';
import '../../../../../../core/widgets/bottomSheet/date_picker_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/slide_button.dart';
import '../../../../../../core/widgets/dashboard_value_container.dart';
import '../../../../../../core/widgets/dialog/custom_dialog.dart';
import '../../../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';
import '../../../../../../core/widgets/shimmer_container.dart';
import '../../../../../../dependency_injection.dart';
import '../bloc/cubit/bank_accounts_cubit.dart';
import '../bloc/cubit/cash_account_download_cubit.dart';
import '../bloc/cubit/cash_account_pie_performance_cubit.dart';
import '../bloc/cubit/cash_account_pie_performance_state.dart';
import '../bloc/cubit/credit_card_transaction_cubit.dart';
import '../bloc/cubit/credit_card_transaction_state.dart';
import '../widgets/cash_account_pie_chart.dart';

class BankAccountSummary extends StatefulWidget {
  final ManualBankAccountsEntity? accountData;
  final String accountID;

  const BankAccountSummary(
      {Key? key, this.accountData, required this.accountID})
      : super(key: key);

  @override
  State<BankAccountSummary> createState() => _BankAccountSummaryState();
}

class _BankAccountSummaryState extends State<BankAccountSummary> {
  late ManualBankAccountsEntity accountDetails;
  PageController pageController = PageController();
  String pickedDate = DateTime.now().toString();
  int pageIndex = 0;
  bool isDeleting = false;
  int currentPageIndex = 1;
  int maxPage = 0;
  num? cashAccountLimit = 0;
  GlobalKey showcaseKey = GlobalKey();
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);
  final ValueNotifier<double> totalDebitAmount = ValueNotifier<double>(0.0);
  final ValueNotifier<double> totalCreditAmount = ValueNotifier<double>(0.0);

  String selectedDate = dateFormatter3.format(DateTime.now());
  final ValueNotifier<bool> _isTransactionFound = ValueNotifier<bool>(true);

  @override
  void initState() {
    /// get data if route coming form Home Page
    context.read<BankAccountsCubit>().getData();

    ///Get Graph data
    context.read<LinePerformanceCubit>().getLinePerformanceData(
          merge: true,
          isFiltered: true,
          isPerformance: true,
          scope: ["fi"],
          fromDate: dateFormatter5
              .format(DateTime(DateTime.now().year, DateTime.now().month, 1)),
          toDate: dateFormatter5.format(
            DateTime(DateTime.now().year, DateTime.now().month + 1, -1),
          ),
          id: widget.accountID,
          assetType: 'CashAccount',
        );

    if (!mounted) return;
    super.initState();
  }

  ///Function get URl for reconnecting the account
  // String getReconnectUrl(Map<String, dynamic> data) {
  //   late String reconnectUrl;
  //   bool isSaltedge = data['provider'].toString().toLowerCase() ==
  //       AggregatorProvider.Saltedge.name.toLowerCase();
  //   bool isYodlee = data['provider'].toString().toLowerCase() ==
  //       AggregatorProvider.Yodlee.name.toLowerCase();
  //
  //   if (isSaltedge) {
  //     reconnectUrl = data['response']['saltedge']['data']['redirect_url'];
  //   } else if (isYodlee) {
  //     ProviderTokenModel providerTokenModel =
  //         ProviderTokenModel.fromJson(data['response']);
  //     String token = providerTokenModel.yodlee!.token.accessToken;
  //     String fastLinkURL = providerTokenModel.yodlee!.fastlinkURL;
  //     String configName = providerTokenModel.yodlee!.fastlinkConfiguration;
  //     String providerAccountId =
  //         accountDetails.aggregatorProviderAccountId.toString();
  //     String htmlString = '''<html>
  //       <body>
  //           <form name="fastlink-form" action="$fastLinkURL" method="POST">
  //               <input name="accessToken" value="Bearer $token" hidden="true" />
  //               <input name="extraParams" value="configName=$configName&flow=refresh&providerAccountId=$providerAccountId" hidden="true" />
  //           </form>
  //           <script type="text/javascript">
  //               window.onload = function () {
  //                   document.forms["fastlink-form"].submit();
  //               }
  //           </script>
  //       </body>
  //       </html>''';
  //
  //     reconnectUrl = Uri.dataFromString(htmlString,
  //             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
  //         .toString();
  //   }
  //   return reconnectUrl;
  // }

  /// Aggregator Reconnection Function
  // _aggregatorReconnect() async {
  //   final data = await context
  //       .read<AggregatorReconnectCubit>()
  //       .refreshAggregator(accountDetails);
  //   if (data != null) {
  //     if (data['status']) {
  //       if (mounted) {
  //         Navigator.push(
  //           context,
  //           CupertinoPageRoute(
  //             builder: (BuildContext context) => AggregatorReconnect(
  //               reconnectUrl: getReconnectUrl(data),
  //               status: (val) async {
  //                 if (val) {
  //                   showSnackBar(
  //                       context: context, title: "Refreshing the account...");
  //                   await RootApplicationAccess().storeAssets();
  //                   await RootApplicationAccess().storeLiabilities();
  //                 }
  //                 if (mounted) {
  //                   Navigator.pop(context);
  //                 }
  //               },
  //             ),
  //           ),
  //         );
  //       }
  //     } else {
  //       showSnackBar(context: context, title: "${data['msg']}!");
  //     }
  //   }
  // }

  ///Function to get data when page refreshes.
  void getData() {
    getTransactionDataByPage(pageIndex: currentPageIndex);
    //GetPieGraphData
    context
        .read<CashAccountPiePerformanceCubit>()
        .getCashAccountPiePerformanceData(
            aggregatorAccountId: accountDetails.aggregatorId.toString(),
            month: dateFormatter3.format(DateTime.now()));
  }

  ///Function to get transaction data.
  void getTransactionDataByPage({required int pageIndex}) {
    //GetTransactionData
    context.read<CashAccountTransactionCubit>().getCashAccountTransactionData(
        source: accountDetails.source!,
        date: selectedDate,
        page: pageIndex.toString(),
        aggregatorAccountId: accountDetails.aggregatorId.toString());
  }

  ///Function to Download transaction details.
  downloadTransactionDetailsDocument(
      {required String aggregatorAccountId, required String month}) {
    context
        .read<CashAccountDownloadCubit>()
        .downloadSummary(aggregatorId: aggregatorAccountId, month: month);
  }

  ///Function to show popup.
  // showPopupBox(context, String message) {
  //   locator.get<WedgeDialog>().confirm(
  //       context,
  //       WedgeConfirmDialog(
  //           title: 'Reconnect Account',
  //           subtitle: message,
  //           acceptedPress: () {
  //             _aggregatorReconnect();
  //             Navigator.pop(context);
  //           },
  //           primaryButtonColor: const Color(0xffEA943E),
  //           deniedPress: () {
  //             ShowCaseWidget.of(context).startShowCase([showcaseKey]);
  //             Navigator.pop(context);
  //           },
  //           acceptText: 'Reconnect',
  //           showReconnectIcon: true,
  //           deniedText: 'Later'));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: Builder(
        builder: (context) =>
            BlocConsumer<BankAccountsCubit, BankAccountsState>(
          listener: (context, state) {
            if (state is BankAccountsLoaded) {
              accountDetails = state.assets.bankAccounts
                  .firstWhere((element) => element.id == widget.accountID);

              String? popupMessage =
                  aggregatorPopupMessage(data: accountDetails);

              if (popupMessage != null) {
                showPopupBox(
                    context: context,
                    message: popupMessage,
                    showcaseKey: showcaseKey,
                    mounted: mounted,
                    data: accountDetails);
                setState(() {});
              }
              getData();
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is BankAccountsLoading) {
              return Center(
                child: buildCircularProgressIndicator(width: 22),
              );
            } else if (state is BankAccountsError) {
              Navigator.pop(context);
              showSnackBar(context: context, title: state.errorMsg);
            } else if (state is BankAccountsLoaded) {
              accountDetails = state.assets.bankAccounts
                  .firstWhere((element) => element.id == widget.accountID);
              return WillPopScope(
                onWillPop: () async {
                  return true;
                },
                child: Scaffold(
                  backgroundColor: appThemeColors!.bg,
                  appBar: wedgeAppBar(
                    context: context,
                    title: translate!.cashAccounts,
                    leadingIcon: getLeadingIcon(context, false),
                  ),
                  body: ValueListenableBuilder<bool>(
                    valueListenable: _isTransactionFound,
                    builder: (context, isTransactionDataFound, child) {
                      var data = accountDetails;
                      String getSubtitle() {
                        String subtitleString = '';
                        if (data.name != "") {
                          subtitleString = "$subtitleString${data.name}";
                        }
                        if (data.aggregatorAccountNumber != "") {
                          if (data.name != "") {
                            subtitleString = "$subtitleString  |  ";
                          }
                          subtitleString =
                              "$subtitleString AC No. ${getAccountFormat(data.aggregatorAccountNumber)}";
                        }
                        return subtitleString;
                      }

                      return SingleChildScrollView(
                        child: ValueListenableBuilder<double>(
                            valueListenable: totalDebitAmount,
                            builder: (context, totalDebitAmountValue, _) {
                              return ValueListenableBuilder<double>(
                                  valueListenable: totalCreditAmount,
                                  builder:
                                      (context, totalCreditAmountValue, _) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(children: [
                                        ValueListenableBuilder(
                                          valueListenable: lastDayPerformance,
                                          builder: (context, value, child) {
                                            return DashboardValueContainer(
                                              showOnlyTop: true,
                                              mainValue:
                                                  "${data.currentAmount.currency} ${data.currentAmount.amount}",
                                              mainTitle: translate!.cashBalance,
                                              leftImage:
                                                  "assets/icons/creditcardMainContainer.png",
                                              summary: value,
                                            );
                                          },
                                        ),
                                        customListTile(
                                            accountData: accountDetails,
                                            title: data.providerName,
                                            subtitle: getSubtitle(),
                                            leadingImage: data.aggregatorLogo,
                                            source: data.source,
                                            isProvider:
                                                data.source?.toLowerCase() !=
                                                    "manual"),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: size.width * .6,
                                                child: WedgeSlideButton(
                                                  pageController:
                                                      pageController,
                                                  pageIndex: pageIndex,
                                                  labelFirst:
                                                      translate!.outFlow,
                                                  labelSecond:
                                                      translate!.inFlow,
                                                ),
                                              ),
                                              DatePickerBottomSheet(
                                                onChange: (value) {
                                                  selectedDate = dateFormatter3
                                                      .format(DateTime.parse(
                                                          value.toString()));
                                                  pickedDate = value;
                                                  // Transaction Details
                                                  context
                                                      .read<
                                                          CashAccountTransactionCubit>()
                                                      .getCashAccountTransactionData(
                                                          source: data.source!,
                                                          date: dateFormatter3
                                                              .format(DateTime
                                                                  .parse(value
                                                                      .toString())),
                                                          page: "1",
                                                          aggregatorAccountId:
                                                              accountDetails!
                                                                  .aggregatorId
                                                                  .toString());

                                                  //Pie Performance
                                                  context
                                                      .read<
                                                          CashAccountPiePerformanceCubit>()
                                                      .getCashAccountPiePerformanceData(
                                                          aggregatorAccountId:
                                                              data.aggregatorId
                                                                  .toString(),
                                                          month: dateFormatter3
                                                              .format(DateTime
                                                                  .parse(value
                                                                      .toString())));

                                                  //Line Performance
                                                  context.read<LinePerformanceCubit>().getLinePerformanceData(
                                                      merge: true,
                                                      isPerformance: true,
                                                      isFiltered: true,
                                                      scope: ["fi"],
                                                      fromDate: dateFormatter5
                                                          .format(DateTime(
                                                              DateTime.parse(value.toString())
                                                                  .year,
                                                              DateTime.parse(value
                                                                      .toString())
                                                                  .month,
                                                              1)),
                                                      toDate: dateFormatter5.format(
                                                          DateTime(
                                                              DateTime.parse(value
                                                                      .toString())
                                                                  .year,
                                                              DateTime.parse(value.toString())
                                                                      .month +
                                                                  1,
                                                              -1)),
                                                      id: data.id.toString(),
                                                      assetType: 'CashAccount');
                                                  setState(() {});
                                                },
                                                initDate: DateTime.now(),
                                                createdAt: data.createdAt!,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.30,
                                          child: PageView(
                                            physics: const BouncingScrollPhysics(
                                                parent:
                                                    AlwaysScrollableScrollPhysics()),
                                            controller: pageController,
                                            onPageChanged: (int index) {
                                              setState(() {
                                                pageIndex = index;
                                              });
                                            },
                                            children: [
                                              BlocBuilder<
                                                  CashAccountPiePerformanceCubit,
                                                  CashAccountPiePerformanceState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is CashAccountPiePerformanceLoading) {
                                                    return Center(
                                                      child:
                                                          CustomShimmerContainer(
                                                        height:
                                                            size.height * .25,
                                                      ),
                                                    );
                                                  } else if (state
                                                      is CashAccountPiePerformanceError) {
                                                    return Center(
                                                        child: Text(
                                                            state.errorMsg));
                                                  } else if (state
                                                      is CashAccountPiePerformanceLoaded) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              CashAccountPieGraph(
                                                            currencyType:
                                                                accountDetails
                                                                    .currentAmount
                                                                    .currency,
                                                            date: pickedDate,
                                                            pieChartData: state
                                                                .cashAccountPiePerformanceModel,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        state.cashAccountPiePerformanceModel
                                                                .isEmpty
                                                            ? Text(
                                                                translate!
                                                                    .noExpenseDataAvailable,
                                                                style:
                                                                    TitleHelper
                                                                        .h12,
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/icons/up_arrow.png",
                                                                    scale: 3.5,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                    "${translate!.outFlow} ${data.currentAmount.currency} ${numberFormat1.format(num.parse(totalCreditAmountValue.toStringAsFixed(2)))}",
                                                                    style:
                                                                        TitleHelper
                                                                            .h12,
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                              BlocConsumer<LinePerformanceCubit,
                                                  LinePerformanceState>(
                                                listener: (context, state) {
                                                  if (state
                                                      is LinePerformanceLoaded) {
                                                    lastDayPerformance.value =
                                                        state
                                                            .linePerformanceModel
                                                            .merge
                                                            ?.fi
                                                            ?.lastDayPerformance;
                                                  }
                                                },
                                                builder: (context, state) {
                                                  double graphHeight =
                                                      size.height * .25;
                                                  if (state
                                                      is LinePerformanceLoading) {
                                                    return buildCircularProgressIndicator();
                                                  } else if (state
                                                      is LinePerformanceLoaded) {
                                                    return Column(
                                                      children: [
                                                        SizedBox(
                                                          height: graphHeight,
                                                          child: state
                                                                  .data.isEmpty
                                                              ? Center(
                                                                  child: Text(
                                                                    translate!
                                                                        .noDataFound,
                                                                    style:
                                                                        SubtitleHelper
                                                                            .h10,
                                                                  ),
                                                                )
                                                              : WedgeEcharts(
                                                                  // index: 2,
                                                                  showTransDate:
                                                                      true,
                                                                  isFiltered: state
                                                                      .isFiltered,
                                                                  currency: state
                                                                      .baseCurrency,
                                                                  data: state
                                                                      .data,
                                                                ),
                                                        ),
                                                        state.data.isEmpty
                                                            ? Text(
                                                                translate!
                                                                    .noExpenseDataAvailable,
                                                                style:
                                                                    TitleHelper
                                                                        .h12,
                                                              )
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    "assets/icons/down_arrow.png",
                                                                    scale: 3.5,
                                                                  ),
                                                                  const SizedBox(
                                                                      width: 6),
                                                                  Text(
                                                                    "${translate!.inFlow}  ${data.currentAmount.currency}  ${numberFormat1.format(num.parse(totalDebitAmountValue.toStringAsFixed(2)))}",
                                                                    style:
                                                                        TitleHelper
                                                                            .h12,
                                                                  ),
                                                                ],
                                                              )
                                                      ],
                                                    );
                                                  } else {
                                                    return const SizedBox
                                                        .shrink();
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        BlocConsumer<
                                            CashAccountTransactionCubit,
                                            CashAccountTransactionState>(
                                          listener: (context, state) {
                                            if (state
                                                is CashAccountTransactionLoaded) {
                                              if (state.showDeleteSnack ??
                                                  false) {
                                                showSnackBar(
                                                    context: context,
                                                    title:
                                                        "Credit Card deleted!");
                                                setState(() {
                                                  isDeleting = false;
                                                });
                                              }
                                              var stateDate = state
                                                  .cashAccountTransactionModel;
                                              totalCreditAmount.value =
                                                  stateDate.summary
                                                          ?.totalCreditAmount ??
                                                      0;
                                              totalCreditAmount
                                                  .notifyListeners();
                                              totalDebitAmount.value = stateDate
                                                      .summary
                                                      ?.totalDebitAmount ??
                                                  0;
                                              totalDebitAmount
                                                  .notifyListeners();
                                            }
                                            if (state
                                                is CashAccountTransactionError) {
                                              showSnackBar(
                                                  context: context,
                                                  title: state.errorMsg);
                                              setState(() {
                                                isDeleting = false;
                                              });
                                            }
                                          },
                                          builder: (context, state) {
                                            if (state
                                                is CashAccountTransactionLoaded) {
                                              var stateDate = state
                                                  .cashAccountTransactionModel;
                                              var records = stateDate.records;
                                              return Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      translate!
                                                          .transactionDetails,
                                                      style: TitleHelper.h9,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  records?.isEmpty ?? false
                                                      ? Center(
                                                          child: Text(
                                                            translate!
                                                                .noTransactionFound,
                                                            style:
                                                                SubtitleHelper
                                                                    .h10,
                                                          ),
                                                        )
                                                      : Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    blurRadius:
                                                                        10,
                                                                    offset:
                                                                        Offset(
                                                                            -1,
                                                                            4))
                                                              ]),
                                                          child: Column(
                                                            children: List.generate(
                                                                records?.length ??
                                                                    0, (index) {
                                                              var data =
                                                                  records?[
                                                                      index];
                                                              return Container(
                                                                width:
                                                                    size.width,
                                                                decoration: BoxDecoration(
                                                                    border: (index ==
                                                                            records!.length -
                                                                                1)
                                                                        ? null
                                                                        : const Border(
                                                                            bottom:
                                                                                BorderSide(color: Colors.black26))),
                                                                margin: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        1),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(10),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              4),
                                                                      child: Image
                                                                          .asset(
                                                                        "${data?.baseType}".toLowerCase() ==
                                                                                "debit"
                                                                            ? "assets/icons/down_arrow.png"
                                                                            : "assets/icons/up_arrow.png",
                                                                        scale:
                                                                            4,
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                data?.merchant?.name != null ? "${data?.merchant?.name}" : "Unknown",
                                                                                style: SubtitleHelper.h11,
                                                                              ),
                                                                              Text(
                                                                                "${data?.amount?.currency} ${numberFormat1.format(data?.amount?.amount)}",
                                                                                style: TitleHelper.h11,
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Text(
                                                                                  "${data?.category}",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                  style: TitleHelper.h11,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                dateFormatter7.format(DateTime.parse("${data?.date}")),
                                                                                style: SubtitleHelper.h11,
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                  pageRouter(records!, state)
                                                ],
                                              );
                                            } else if (state
                                                is CashAccountTransactionLoading) {
                                              return Center(
                                                  child:
                                                      buildCircularProgressIndicator(
                                                          width: 200));
                                            } else if (state
                                                is CashAccountTransactionError) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        )
                                      ]),
                                    );
                                  });
                            }),
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  ///Function to create Page Router.
  Visibility pageRouter(
      List<Record> records, CashAccountTransactionLoaded state) {
    var cursor = state.cashAccountTransactionModel.cursor;
    maxPage = ((cursor?.totalRecords ?? 1) / (cursor?.perPage ?? 1)).ceil();
    return Visibility(
      visible: ((records.isNotEmpty)),
      child: Container(
        margin: const EdgeInsets.only(top: 25, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  if (currentPageIndex != 1) {
                    setState(() {
                      currentPageIndex--;
                    });
                    getTransactionDataByPage(pageIndex: currentPageIndex);
                  }
                },
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: currentPageIndex == 1
                      ? Colors.grey
                      : appThemeColors?.primary,
                )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 12),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(.2),
              ),
              child: Text(
                '$currentPageIndex',
                style: TitleHelper.h12,
              ),
            ),
            GestureDetector(
                onTap: () {
                  if (maxPage > currentPageIndex) {
                    setState(() {
                      currentPageIndex++;
                    });
                    getTransactionDataByPage(pageIndex: currentPageIndex);
                  }
                },
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: (maxPage == currentPageIndex) || (records.isEmpty)
                      ? Colors.grey
                      : appThemeColors?.primary,
                )),
          ],
        ),
      ),
    );
  }

  ///Function to get a Custom ListTile.
  ListTile customListTile({
    String? title,
    String? subtitle,
    String? leadingImage,
    bool? isProvider,
    String? source,
    required ManualBankAccountsEntity? accountData,
  }) {
    bool isExpired = isAggregatorExpired(data: accountData);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.network(
        height: 40,
        width: 40,
        "$leadingImage",
        placeholderBuilder: (context) {
          return Image.asset(
            "assets/icons/persoanlLoanMainContainer.png",
            height: 40,
            width: 40,
          );
        },
        // Additional optional parameters
      ),
      title: Text(
        "$title",
        style: TitleHelper.h10,
      ),
      subtitle: Text("$subtitle"),
      trailing: ShowcaseContainer(
        showcaseKey: showcaseKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: isExpired
              ? const EdgeInsets.only(left: 20, top: 0, bottom: 0)
              : EdgeInsets.zero,
          child: Stack(
            children: [
              isExpired
                  ? Positioned(
                      left: 0,
                      top: 15,
                      child: Image.asset(
                        'assets/icons/reconnect_warning.png',
                        height: 16,
                      ),
                    )
                  : const SizedBox(),
              PopupMenuButton<int>(
                  offset: const Offset(0, 50),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.more_vert_rounded,
                    size: 25,
                    color: appThemeColors!.primary!,
                  ),
                  onSelected: (index) {
                    if (index == 3) {
                      locator.get<WedgeDialog>().confirm(
                          context,
                          WedgeConfirmDialog(
                            title: translate!.areYouSure,
                            subtitle: accountDetails.source?.toLowerCase() ==
                                    AggregatorProvider.Saltedge.name
                                        .toLowerCase()
                                ? translate!.saltEdgeDeleteConfirmation
                                : translate!.yodleeDeleteConfirmation,
                            acceptText: translate!.yesDelete,
                            deniedText: translate!.noiWillKeepIt,
                            acceptedPress: () async {
                              showSnackBar(
                                  context: context,
                                  title: translate!.loading,
                                  duration: const Duration(seconds: 5));
                              setState(() {
                                isDeleting = true;
                              });
                              await context
                                  .read<BankAccountsCubit>()
                                  .deleteBankAccount(accountDetails.id);
                              Navigator.pop(context);
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context);
                            },
                            deniedPress: () {
                              Navigator.pop(context);
                            },
                          ));
                    }
                  },
                  color: Colors.white,
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          value: 1,
                          onTap: () {
                            ReconnectAggregator.aggregatorReconnect(
                                mounted: mounted, dataEntity: accountDetails);
                          },
                          child: Container(
                            child: popUpItem(
                              '${translate!.reconnect} ${translate?.account}',
                              highlight:
                                  isAggregatorExpired(data: accountDetails),
                              subtitle:
                                  aggregatorExpireMessage(data: accountDetails),
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          onTap: () {
                            downloadTransactionDetailsDocument(
                                aggregatorAccountId:
                                    accountDetails.aggregatorId,
                                month: selectedDate);
                          },
                          value: 2,
                          child:
                              Container(child: popUpItem(translate!.download)),
                        ),
                        PopupMenuItem(
                          padding: EdgeInsets.zero,
                          value: 3,
                          child: popUpItem(
                            translate!.unlinkAccount,
                          ),
                        ),
                      ]),
            ],
          ),
        ),
      ),
    );
  }
}
