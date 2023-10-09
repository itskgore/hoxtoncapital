import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/widgets/custom_assets_showcase.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/credit_card_pie_performance_state.dart';
import 'package:wedge/features/liabilities/credit_card/credit_card_debt_main/presentation/cubit/creditcardexceldownload_cubit.dart';

import '../../../../../../core/common/functions/common_functions.dart';
import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/config/app_config.dart';
import '../../../../../../core/contants/enums.dart';
import '../../../../../../core/contants/string_contants.dart';
import '../../../../../../core/entities/credit_cards_entity.dart';
import '../../../../../../core/usecases/usecase.dart';
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
import '../cubit/credit_card_pie_performance_cubit.dart';
import '../cubit/credit_card_transaction_cubit.dart';
import '../cubit/credit_card_transaction_state.dart';
import '../cubit/main_credit_card_cubit.dart';
import '../widget/credit_card_pie_chart.dart';

class CreditCardAccountSummary extends StatefulWidget {
  final CreditCardsEntity cardData;

  const CreditCardAccountSummary({Key? key, required this.cardData})
      : super(key: key);

  @override
  State<CreditCardAccountSummary> createState() =>
      _CreditCardAccountSummaryState();
}

class _CreditCardAccountSummaryState extends State<CreditCardAccountSummary> {
  AppLocalizations? translate;
  PageController pageController = PageController();
  int pageIndex = 0;
  bool isDeleting = false;
  int currentPageIndex = 1;
  int maxPage = 0;
  num? creditCardLimit = 0;
  String selectedDate = dateFormatter3.format(DateTime.now());
  String pickedDate = DateTime.now().toString();
  final ValueNotifier<bool> _isTransactionFound = ValueNotifier<bool>(true);
  final GlobalKey _showcaseKey = GlobalKey();
  bool firstTime = true;
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);

  @override
  void initState() {
    creditLimit();
    getTransactionDataByPage(pageIndex: currentPageIndex);

    // GetLineGraphData
    context.read<LinePerformanceCubit>().getLinePerformanceData(
        merge: true,
        isFiltered: false,
        scope: ["fi"],
        isPerformance: true,
        fromDate: dateFormatter5.format(
          DateTime(DateTime.now().year, DateTime.now().month, 1),
        ),
        toDate: dateFormatter5.format(
          DateTime(DateTime.now().year, DateTime.now().month + 1, -1),
        ),
        id: widget.cardData.id.toString(),
        assetType: 'creditCard');

    //GetPieGraphData
    context
        .read<CreditCardPiePerformanceCubit>()
        .getCreditCardPiePerformanceData(
            aggregatorAccountId: widget.cardData.aggregatorId.toString(),
            month: dateFormatter3.format(DateTime.now()));
    super.initState();
  }

  // Function for getting reconnectUrl for given provider (Saltedge / Yodlee)
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
  //         widget.cardData.aggregatorProviderAccountId.toString();
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

  // Aggregator Reconnection Function
  // _aggregatorReconnect() async {
  //   final data = await context
  //       .read<AggregatorReconnectCubit>()
  //       .refreshAggregator(widget.cardData);
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

  void getTransactionDataByPage({required int pageIndex}) {
    //GetTransactionData
    context.read<CreditCardTransactionCubit>().getCreditCardTransactionData(
        source: widget.cardData.source,
        date: selectedDate,
        page: pageIndex.toString(),
        aggregatorAccountId: widget.cardData.aggregatorId.toString());
  }

  downloadTransactionDetailsDocument(
      {required String aggregatorAccountId, required String month}) {
    context
        .read<CreditCardExcelDownloadCubit>()
        .downloadSummary(aggregatorId: aggregatorAccountId, month: month);
  }

  creditLimit() {
    var assets = widget.cardData;
    if (assets.creditLimit?.amount != 0) {
      creditCardLimit = assets.creditLimit?.amount;
    } else if (assets.totalCreditLine.amount != 0) {
      creditCardLimit = assets.totalCreditLine.amount;
    } else if (assets.aggregator?.extra?.credit_limit != 0 &&
        assets.aggregator?.extra?.credit_limit != '') {
      creditCardLimit = assets.aggregator?.extra?.credit_limit;
    } else {
      creditCardLimit = 0;
    }
  }

  // showPopupBox(context, String message) {
  //   locator.get<WedgeDialog>().confirm(
  //       context,
  //       WedgeConfirmDialog(
  //           title: 'Reconnect Account',
  //           subtitle: message,
  //           acceptedPress: () {
  //             // _aggregatorReconnect();
  //             ReconnectAggregator.aggregatorReconnect(
  //                 dataEntity: widget.cardData, mounted: mounted);
  //             Navigator.pop(context);
  //           },
  //           primaryButtonColor: Color(0xffEA943E),
  //           deniedPress: () {
  //             ShowCaseWidget.of(context).startShowCase([_showcaseKey]);
  //             Navigator.pop(context);
  //           },
  //           acceptText: 'Reconnect',
  //           showReconnectIcon: true,
  //           deniedText: 'Later'));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    var data = widget.cardData;
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
            "$subtitleString AC No. ${data.aggregatorAccountNumber}";
      }
      return subtitleString;
    }

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => WillPopScope(
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
            ),
            body: ValueListenableBuilder<bool>(
              valueListenable: _isTransactionFound,
              builder: (context, isTransactionDataFound, child) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(children: [
                      ValueListenableBuilder(
                        valueListenable: lastDayPerformance,
                        builder: (context, value, child) {
                          return DashboardValueContainer(
                            showOnlyTop: true,
                            mainValue:
                                "${widget.cardData.outstandingAmount.currency} ${widget.cardData.outstandingAmount.amount}",
                            mainTitle: translate!.outstandingValue,
                            summary: value,
                            leftImage:
                                "assets/icons/creditcardMainContainer.png",
                          );
                        },
                      ),
                      customListTile(
                          title: widget.cardData.providerName,
                          subtitle: getSubtitle(),
                          leadingImage: widget.cardData.aggregatorLogo,
                          isProvider:
                              widget.cardData.source.toLowerCase() != "manual"),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width * .6,
                              child: WedgeSlideButton(
                                pageController: pageController,
                                pageIndex: pageIndex,
                                labelFirst: translate!.categories,
                                labelSecond: translate!.balance,
                              ),
                            ),
                            DatePickerBottomSheet(
                              onChange: (value) {
                                selectedDate = dateFormatter3
                                    .format(DateTime.parse(value.toString()));
                                pickedDate = value;

                                log("value: $value");
                                // Transaction Details
                                context
                                    .read<CreditCardTransactionCubit>()
                                    .getCreditCardTransactionData(
                                        source: widget.cardData.source,
                                        date: dateFormatter3.format(
                                            DateTime.parse(value.toString())),
                                        page: "1",
                                        aggregatorAccountId: widget
                                            .cardData.aggregatorId
                                            .toString());

                                //Pie Performance
                                context
                                    .read<CreditCardPiePerformanceCubit>()
                                    .getCreditCardPiePerformanceData(
                                        aggregatorAccountId: widget
                                            .cardData.aggregatorId
                                            .toString(),
                                        month: dateFormatter3.format(
                                            DateTime.parse(value.toString())));

                                //Line Performance
                                context
                                    .read<LinePerformanceCubit>()
                                    .getLinePerformanceData(
                                        merge: true,
                                        isPerformance: true,
                                        isFiltered: true,
                                        scope: ["fi"],
                                        fromDate: dateFormatter5
                                            .format(DateTime(
                                                DateTime.parse(value.toString())
                                                    .year,
                                                DateTime.parse(value.toString())
                                                    .month,
                                                1)),
                                        toDate: dateFormatter5.format(DateTime(
                                            DateTime.parse(value.toString())
                                                .year,
                                            DateTime.parse(value.toString())
                                                    .month +
                                                1,
                                            -1)),
                                        id: widget.cardData.id.toString(),
                                        assetType: 'creditCard');
                                setState(() {});
                              },
                              initDate: DateTime.now(),
                              createdAt: widget.cardData.createdAt,
                              showOneYearDateRange: false,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.33,
                        child: PageView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          controller: pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              pageIndex = index;
                            });
                          },
                          children: [
                            BlocBuilder<CreditCardPiePerformanceCubit,
                                CreditCardPiePerformanceState>(
                              builder: (context, state) {
                                if (state is CreditCardPiePerformanceLoading) {
                                  return Center(
                                    child: CustomShimmerContainer(
                                      height: size.height * .25,
                                    ),
                                  );
                                } else if (state
                                    is CreditCardPiePerformanceError) {
                                  return Center(child: Text(state.errorMsg));
                                } else if (state
                                    is CreditCardPiePerformanceLoaded) {
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        child: CreditCardPieGraph(
                                          currencyType: widget.cardData
                                              .outstandingAmount.currency,
                                          date: pickedDate,
                                          pieChartData: state
                                              .creditCardPiePerformanceModel,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      state.creditCardPiePerformanceModel
                                              .isEmpty
                                          ? Text(
                                              translate!.noExpenseDataAvailable,
                                              style: TitleHelper.h12,
                                            )
                                          : Text(
                                              translate!.expenseCategories,
                                              style: TitleHelper.h12,
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
                                if (state is LinePerformanceLoaded) {
                                  lastDayPerformance.value = state
                                      .linePerformanceModel
                                      .merge
                                      ?.fi
                                      ?.lastDayPerformance;
                                }
                              },
                              builder: (context, state) {
                                if (state is LinePerformanceLoading) {
                                  return buildCircularProgressIndicator();
                                } else if (state is LinePerformanceLoaded) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: size.height * .25,
                                          child: state.data.isEmpty
                                              ? Center(
                                                  child: Text(
                                                    translate!.noDataFound,
                                                    style: SubtitleHelper.h10,
                                                  ),
                                                )
                                              : WedgeEcharts(
                                                  showTransDate: true,
                                                  isFiltered: state.isFiltered,
                                                  currency: state.baseCurrency,
                                                  data: state.data,
                                                )),
                                      Visibility(
                                          visible: state.data.isNotEmpty,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Text(
                                              translate!.monthlyExpenseFlow,
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
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${translate!.creditLimit}:",
                              style: SubtitleHelper.h11,
                            ),
                            Text(
                              "${widget.cardData.outstandingAmount.currency} ${numberFormat1.format(creditCardLimit)}",
                              style: TitleHelper.h11,
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<CreditCardTransactionCubit,
                          CreditCardTransactionState>(
                        listener: (context, state) {
                          if (state is CreditCardTransactionLoaded) {
                            if (state.showDeleteSnack ?? false) {
                              showSnackBar(
                                  context: context,
                                  title: "Credit Card deleted!");
                              setState(() {
                                isDeleting = false;
                              });
                            } else {
                              String? popupMessage =
                                  aggregatorPopupMessage(data: widget.cardData);
                              if (popupMessage != null && firstTime) {
                                firstTime = false;
                                showPopupBox(
                                    context: context,
                                    message: popupMessage,
                                    data: data,
                                    mounted: mounted,
                                    showcaseKey: _showcaseKey);
                                setState(() {});
                              }
                            }
                          }
                          if (state is CreditCardTransactionError) {
                            showSnackBar(
                                context: context, title: state.errorMsg);
                            setState(() {
                              isDeleting = false;
                            });
                          }
                        },
                        builder: (context, state) {
                          if (state is CreditCardTransactionLoaded) {
                            var records =
                                state.creditCardTransactionModel.records;
                            // if (records?.isEmpty ?? false) {
                            //   _isTransactionFound.value = false;
                            //   _isTransactionFound.notifyListeners();
                            // } else {
                            //   _isTransactionFound.value = true;
                            //   _isTransactionFound.notifyListeners();
                            // }
                            return Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    translate!.transactionDetails,
                                    style: TitleHelper.h9,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                records?.isEmpty ?? false
                                    ? Center(
                                        child: Text(
                                          translate!.noTransactionFound,
                                          style: SubtitleHelper.h10,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 10,
                                                  offset: Offset(-1, 4))
                                            ]),
                                        child: Column(
                                          children: List.generate(
                                              records?.length ?? 0, (index) {
                                            var data = records?[index];
                                            return Container(
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                  border: (index ==
                                                          records!.length - 1)
                                                      ? null
                                                      : const Border(
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black26))),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 4),
                                                    child: Image.asset(
                                                      "${data?.baseType}"
                                                                  .toLowerCase() ==
                                                              "debit"
                                                          ? "assets/icons/down_arrow.png"
                                                          : "assets/icons/up_arrow.png",
                                                      scale: 4,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              data?.merchant
                                                                          ?.name !=
                                                                      null
                                                                  ? "${data?.merchant?.name}"
                                                                  : "Unknown",
                                                              style:
                                                                  SubtitleHelper
                                                                      .h11,
                                                            ),
                                                            Text(
                                                              "${data?.amount?.currency} ${numberFormat1.format(data?.amount?.amount)}",
                                                              style: TitleHelper
                                                                  .h11,
                                                            )
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${data?.category}",
                                                              style: TitleHelper
                                                                  .h11,
                                                            ),
                                                            Text(
                                                              dateFormatter7.format(
                                                                  DateTime.parse(
                                                                      "${data?.date}")),
                                                              style:
                                                                  SubtitleHelper
                                                                      .h11,
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
                          } else if (state is CreditCardTransactionLoading) {
                            return Center(
                                child:
                                    buildCircularProgressIndicator(width: 200));
                          } else if (state is CreditCardTransactionError) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container();
                          }
                        },
                      )
                    ]),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Visibility pageRouter(
      List<Record> records, CreditCardTransactionLoaded state) {
    var cursor = state.creditCardTransactionModel.cursor;
    maxPage = ((cursor?.totalRecords ?? 1) / (cursor?.perPage ?? 1)).ceil();
    return Visibility(
      visible: ((records.isNotEmpty ?? false)),
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
                  color:
                      maxPage == currentPageIndex || (records?.isEmpty ?? false)
                          ? Colors.grey
                          : appThemeColors?.primary,
                )),
          ],
        ),
      ),
    );
  }

  ListTile customListTile(
      {String? title,
      String? subtitle,
      String? leadingImage,
      bool? isProvider}) {
    bool isExpired = isAggregatorExpired(data: widget.cardData);
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
        showcaseKey: _showcaseKey,
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
                  : SizedBox(),
              BlocBuilder<CreditCardExcelDownloadCubit,
                  CreditCardExcelDownloadState>(
                builder: (context, state) {
                  if (state is CreditcardexceldownloadLoading) {
                    return buildCircularProgressIndicator(width: 20);
                  }
                  return PopupMenuButton<int>(
                      offset: Offset(0, 50),
                      onSelected: (int selectedIndex) {
                        // TODO : add download option
                        switch (selectedIndex) {
                          // Option1: Reconnect
                          case 1:
                            {
                              // _aggregatorReconnect();
                              ReconnectAggregator.aggregatorReconnect(
                                  dataEntity: widget.cardData,
                                  mounted: mounted);
                            }
                            break;
                          // Option2: Download
                          case 2:
                            {
                              downloadTransactionDetailsDocument(
                                  aggregatorAccountId:
                                      "${widget.cardData.aggregatorId}",
                                  month: selectedDate);
                            }
                            break;
                          // Option3: Unlink Account
                          case 3:
                            {
                              locator.get<WedgeDialog>().confirm(
                                  context,
                                  WedgeConfirmDialog(
                                      title: translate!.areYouSure,
                                      subtitle: widget.cardData.source
                                                  .toLowerCase() ==
                                              AggregatorProvider.Saltedge.name
                                                  .toLowerCase()
                                          ? translate!
                                              .saltEdgeDeleteConfirmation
                                          : translate!.yodleeDeleteConfirmation,
                                      acceptedPress: () {
                                        showSnackBar(
                                            context: context,
                                            title: translate!.loading,
                                            duration:
                                                const Duration(minutes: 3));

                                        BlocProvider.of<MainCreditCardCubit>(
                                                context,
                                                listen: false)
                                            .deleteCreditCard(DeleteParams(
                                                id: widget.cardData.id));
                                        context
                                            .read<MainCreditCardCubit>()
                                            .getCreditCards();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        // setState(() {
                                        //   isDeleting = true;
                                        // });
                                      },
                                      deniedPress: () {
                                        Navigator.pop(context);
                                      },
                                      acceptText: translate!.yesDelete,
                                      deniedText: translate!.noiWillKeepIt));
                            }
                            break;
                        }
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 25,
                        color: appThemeColors!.primary!,
                      ),
                      color: Colors.white,
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              value: 1,
                              child: popUpItem(
                                  '${translate!.reconnect} ${translate?.account}',
                                  highlight: isExpired,
                                  subtitle: aggregatorExpireMessage(
                                      data: widget.cardData)),
                            ),
                            PopupMenuItem(
                              height: 36,
                              padding: EdgeInsets.zero,
                              value: 2,
                              child: popUpItem(translate!.download),
                            ),
                            PopupMenuItem(
                              height: 36,
                              padding: EdgeInsets.zero,
                              value: 3,
                              child: popUpItem(translate!.unlinkAccount),
                            ),
                          ]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget popUpItem(String title, {Color? color}) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//     child: Align(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         title,
//         textAlign: TextAlign.left,
//         style: SubtitleHelper.h10.copyWith(color: color),
//         // TextStyle(color: appThemeColors!.textDark).copyWith(color: color),
//       ),
//     ),
//   );
// }
}
