import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/custom_assets_showcase.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/your_investments/presentation/cubit/your_investments_cubit.dart';

import '../../../../core/common/functions/common_functions.dart';
import '../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../core/contants/enums.dart';
import '../../../../core/data_models/performence_chart_model.dart';
import '../../../../core/utils/reconnect_aggregator.dart';
import '../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/widgets/assets_menu_popup_item.dart';
import '../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../core/widgets/dialog/reconnect_dialog.dart';
import '../../../../core/widgets/shimmer_container.dart';
import '../../../assets/invesntment/investment_main/presentation/bloc/cubit/investments_cubit.dart';
import '../cubit/investment_notes_cubit.dart';
import '../cubit/your_investment_peformance_cubit.dart';
import '../cubit/your_investment_performance_state.dart';

class YourInvestmentsMain extends StatefulWidget {
  InvestmentEntity investmentEntity;

  YourInvestmentsMain({Key? key, required this.investmentEntity})
      : super(key: key);

  @override
  _YourInvestmentsMainState createState() => _YourInvestmentsMainState();
}

class _YourInvestmentsMainState extends State<YourInvestmentsMain>
    with TickerProviderStateMixin {
  bool isDeletingAccount = false;
  bool notesUpdate = false;
  AppLocalizations? translate;
  String selectedId = "";
  List pickedList = [];
  late TabController _tabController;
  final GlobalKey _showcaseKey = GlobalKey();
  bool firstTime = true;
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);

  @override
  void initState() {
    //Tabs
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    //
    context.read<YourInvestmentsCubit>().getHolding(
        widget.investmentEntity.aggregatorId.toString(),
        widget.investmentEntity.source.toString());
    //
    context.read<YourInvestmentPerformanceCubit>().getInvestmentPerformanceData(
        merge: true,
        isFiltered: false,
        scope: ["fi"],
        fromDate: dateFormatter5.format(
          DateTime.now().subtract(const Duration(days: 30)),
        ),
        toDate: dateFormatter5.format(DateTime.now()),
        id: widget.investmentEntity.id.toString());
    //
    super.initState();
  }

  String getBalance() {
    if (widget.investmentEntity.source!.toLowerCase() == "manual") {
      return "${widget.investmentEntity.balance!.currency} ${widget.investmentEntity.balance!.amount}";
    } else {
      return "${widget.investmentEntity.currentValue.currency} ${widget.investmentEntity.currentValue.amount}";
    }
  }

  changeSelectedState(String id) {
    setState(() {
      selectedId = id;
    });
  }

  removeInvestments(String id) {
    locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
            title: translate!.areYouSure,
            subtitle: widget.investmentEntity.source?.toLowerCase() ==
                    AggregatorProvider.Saltedge.name.toLowerCase()
                ? translate!.saltEdgeDeleteConfirmation
                : translate!.yodleeDeleteConfirmation,
            acceptedPress: () {
              setState(() {
                isDeletingAccount = true;
              });
              showSnackBar(context: context, title: "Loading....");
              context.read<YourInvestmentsCubit>().deleteInvestmentsData(id);
              context.read<InvestmentsCubit>().getData();
              Navigator.pop(context);
            },
            deniedPress: () {
              Navigator.pop(context);
            },
            acceptText: translate!.yesDelete,
            deniedText: translate!.noiWillKeepIt));
  }

  loadGraphData(
      {var data, required List<PerformanceChartModel> chartData}) async {
    if (data.length > 1) {
      for (var i = 1; i < data.length; i++) {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(data[i].first * 1000).toLocal();
        chartData
            .add(PerformanceChartModel(date, double.parse("${data[i][6]}")));
      }
      chartData.sort((a, b) {
        DateTime aDate = a.date;
        DateTime bDate = b.date;
        return aDate.compareTo(bDate);
      });
    }
  }

  getUpdatedDate() {
    return (widget.investmentEntity.aggregator?.lastUpdatedDate != "" &&
            widget.investmentEntity.aggregator?.lastUpdatedDate != null)
        ? dateFormatter12.format(DateTime.parse(
            widget.investmentEntity.aggregator!.lastUpdatedDate!))
        : (widget.investmentEntity.updatedAt != ""
            ? dateFormatter12
                .format(DateTime.parse(widget.investmentEntity.updatedAt!))
            : dateFormatter12
                .format(DateTime.parse(widget.investmentEntity.createdAt!)));
  }

  getUpdatedDateRange() {
    if (widget.investmentEntity.aggregator?.createdDate != null &&
        widget.investmentEntity.aggregator?.createdDate != "") {
      return widget.investmentEntity.aggregator?.createdDate;
    } else {
      return widget.investmentEntity.createdAt;
    }
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
  //         widget.investmentEntity.aggregatorProviderAccountId.toString();
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
  //       .refreshAggregator(widget.investmentEntity);
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

  bool isEdited = false;

  // showPopupBox(context, String message) {
  //   locator.get<WedgeDialog>().confirm(
  //       context,
  //       WedgeConfirmDialog(
  //           title: 'Reconnect Account',
  //           subtitle: message,
  //           acceptedPress: () {
  //             // _aggregatorReconnect();
  //
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
    final List<PerformanceChartModel> chartData = [];
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    DateTime endDate = currentDate;
    bool showTooltip =
        widget.investmentEntity.source?.toLowerCase() != 'hoxton' &&
            DateTime.parse(widget.investmentEntity.createdAt!)
                    .toLocal()
                    .difference(DateTime.now())
                    .inDays
                    .abs() <
                7;

    bool isExpired = isAggregatorExpired(data: widget.investmentEntity);

    return ShowCaseWidget(
      builder: Builder(
        builder: (context) => Scaffold(
          backgroundColor: appThemeColors!.bg,
          appBar: wedgeAppBar(
              context: context,
              title: translate!.investments,
              leadingIcon: IconButton(
                  onPressed: () {
                    if (!isDeletingAccount) {
                      if (isEdited) {
                        Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, notesUpdate);
                      }
                    }
                  },
                  icon: Icon(Platform.isIOS
                      ? Icons.arrow_back_ios
                      : Icons.arrow_back))),
          body: WillPopScope(
            onWillPop: () async {
              if (isEdited) {}
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  ValueListenableBuilder(
                    valueListenable: lastDayPerformance,
                    builder: (context, value, child) {
                      return DashboardValueContainer(
                          mainValue: getBalance(),
                          mainTitle: translate!.investmentAccBalance,
                          summary: value,
                          leftImage: "",
                          showOnlyTop: true,
                          leftValue: "",
                          leftTitle: "",
                          rightTitle: "",
                          rightvalue: "");
                    },
                  ),
                  ListTile(
                    leading: widget.investmentEntity.source?.toLowerCase() ==
                                "hoxton" ||
                            widget.investmentEntity.source?.toLowerCase() !=
                                "manual"
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: FadeInImage.assetNetwork(
                              placeholder:
                                  'assets/icons/persoanlLoanMainContainer.png',
                              image:
                                  widget.investmentEntity.aggregatorLogo ?? "",
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/icons/persoanlLoanMainContainer.png",
                                  height: 40,
                                  width: 40,
                                );
                              },
                              height: 40,
                              width: 40,
                            ),
                          )
                        : Image.asset(
                            "assets/icons/persoanlLoanMainContainer.png",
                            height: 40,
                            width: 40,
                          ),
                    title: Text(
                        // widget.investmentEntity.name.length > 30
                        //     ? "${widget.investmentEntity.name.substring(0, 20)}..."
                        //     :
                        widget.investmentEntity.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TitleHelper.h10),
                    subtitle: Text(widget.investmentEntity.accountType ?? ''),
                    trailing: widget.investmentEntity.source?.toLowerCase() !=
                            'hoxton'
                        ? ShowcaseContainer(
                            showcaseKey: _showcaseKey,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: isExpired
                                  ? const EdgeInsets.only(
                                      left: 20, top: 0, bottom: 0)
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
                                      color: Colors.white,
                                      onSelected: (int selectedIndex) {
                                        switch (selectedIndex) {
                                          // Option1: Reconnect
                                          case 1:
                                            {
                                              // _aggregatorReconnect();
                                              ReconnectAggregator
                                                  .aggregatorReconnect(
                                                      dataEntity: widget
                                                          .investmentEntity,
                                                      mounted: mounted);
                                            }
                                            break;
                                          // Option2: Unlink Account
                                          case 2:
                                            {
                                              removeInvestments(
                                                  widget.investmentEntity.id);
                                            }
                                            break;
                                        }
                                      },
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              value: 1,
                                              // onTap: _aggregatorReconnect,
                                              child: popUpItem(
                                                  '${translate!.reconnect} ${translate?.account}',
                                                  highlight: isExpired,
                                                  subtitle:
                                                      aggregatorExpireMessage(
                                                          data: widget
                                                              .investmentEntity)),
                                            ),
                                            PopupMenuItem(
                                              padding: EdgeInsets.zero,
                                              value: 2,
                                              // onTap: () {
                                              //   removeInvestments(
                                              //       widget.investmentEntity.id);
                                              // },
                                              child: popUpItem(
                                                translate!.unlinkAccount,
                                              ),
                                            ),
                                          ]),
                                ],
                              ),
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  widget.investmentEntity.source?.toLowerCase() != "manual"
                      ? BlocConsumer<YourInvestmentPerformanceCubit,
                          YourInvestmentPerformanceState>(
                          listener: (context, state) {
                            if (state is YourInvestmentPerformanceError) {
                              showSnackBar(
                                  context: context, title: state.errorMsg);
                            }
                            if (state is YourInvestmentPerformanceLoaded) {
                              String? popupMessage = aggregatorPopupMessage(
                                  data: widget.investmentEntity);

                              if (popupMessage != null && firstTime) {
                                firstTime = false;
                                // showPopupBox(context, popupMessage);
                                showPopupBox(
                                    context: context,
                                    message: popupMessage,
                                    data: widget.investmentEntity,
                                    showcaseKey: _showcaseKey,
                                    mounted: mounted);
                                setState(() {});
                              }
                              lastDayPerformance.value = state
                                  .investmentPerformanceModel
                                  .merge
                                  ?.fi
                                  ?.lastDayPerformance;
                              log("Listener called data: ${lastDayPerformance.value?.diff}");
                            }
                          },
                          builder: (context, state) {
                            //: Loading
                            if (state is YourInvestmentPerformanceLoading) {
                              double height = size.height;
                              double chartHeight = height < 700
                                  ? height * 0.4
                                  : height < 800
                                      ? height * .4
                                      : height * 0.3;

                              return CustomShimmerContainer(
                                height: chartHeight,
                              );
                            }
                            //: Loaded
                            else if (state is YourInvestmentPerformanceLoaded) {
                              var data =
                                  state.investmentPerformanceModel.merge!.fi !=
                                          null
                                      ? state.investmentPerformanceModel.merge!
                                          .fi!.performance!
                                      : [];
                              loadGraphData(data: data, chartData: chartData);
                              log(
                                  DateTime.parse(widget
                                              .investmentEntity.createdAt!)
                                          .toLocal()
                                          .toString() ??
                                      '',
                                  name: 'CreatedAt');

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DurationSelectorBottomSheet(
                                          startDate: startDate,
                                          endDate: endDate,
                                          isShowMax: true,
                                          initDateList: pickedList,
                                          createdAt: getUpdatedDateRange(),
                                          onChange: (dates) {
                                            var fromDate = dateFormatter5
                                                .format(dates![0]!);
                                            var toDate = dateFormatter5
                                                .format(dates[1]!);

                                            context
                                                .read<
                                                    YourInvestmentPerformanceCubit>()
                                                .getInvestmentPerformanceData(
                                                    merge: true,
                                                    isFiltered: true,
                                                    scope: ["fi"],
                                                    fromDate: fromDate,
                                                    toDate: toDate,
                                                    id: widget
                                                        .investmentEntity.id
                                                        .toString());

                                            setState(() {
                                              pickedList = dates!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        SizedBox(
                                          width: size.width,
                                          height: size.height * .25,
                                          child: WedgeEcharts(
                                              isFiltered: state.isFiltered,
                                              currency: data[0][5],
                                              data: data),
                                        ),
                                        showTooltip
                                            ? Positioned(
                                                bottom: 80,
                                                left: 46,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                        width: 0.50,
                                                        color:
                                                            Color(0xFFCFCFCF),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                        width: size.width * .67,
                                                        child: Text(
                                                          translate!
                                                              .updatesWillBeAvailableMessage,
                                                          style: SubtitleHelper
                                                              .h11
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    )
                                    // PerformanceChart(
                                    //   chartData: chartData,
                                    //   currencyType:
                                    //       data.length >= 2 ? data[1][5] : 'INR',
                                    // ),
                                  ],
                                ),
                              );
                            }
                            // : Error
                            else if (state is YourInvestmentPerformanceError) {
                              return Center(
                                child: Text(state.errorMsg),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      : const SizedBox(),
                  BlocConsumer<YourInvestmentsCubit, YourInvestmentsState>(
                    listener: (context, state) {
                      if (state is YourInvestmentsLoaded) {
                        if (state.isDeletePerformed) {
                          Navigator.pop(context, true);
                          showSnackBar(
                              context: context,
                              title: translate!.investmentDeleted);
                        }
                      }
                      if (state is YourInvestmentsError) {
                        showSnackBar(context: context, title: state.errorMsg);
                      }
                    },
                    builder: (context, state) {
                      final isProvider =
                          widget.investmentEntity.source?.toLowerCase() !=
                                  'manual' &&
                              widget.investmentEntity.source?.toLowerCase() !=
                                  'hoxton';

                      final isHoxton =
                          widget.investmentEntity.source?.toLowerCase() ==
                              "hoxton";

                      if (state is YourInvestmentsLoading) {
                        return Center(
                          child: buildCircularProgressIndicator(),
                        );
                      } else if (state is YourInvestmentsLoaded) {
                        final data = state.investmentHoldingsEntity;

                        /// Tab List
                        List<Widget> tabsList = [
                          Tab(
                            child: Text(translate!.holdings,
                                style: TitleHelper.h11),
                          ),
                          Tab(
                            child:
                                Text(translate!.notes, style: TitleHelper.h11),
                          ),
                        ];

                        ///Tab Bar List
                        List<Widget> tabBarViewList = [
                          holdingTabView(data),
                          notesTabView(),
                        ];

                        List<Map<String, dynamic>> modelIds = [];

                        for (var e in data) {
                          modelIds.add({'id': e.id, 'name': e.description});
                        }
                        modelIds.add({'id': 'total', 'name': "Total"});
                        // print(modelIds);
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Column(
                            children: [
                              // AggregationResultChart(
                              //   modelId: modelIds,
                              //   isHolding: true,
                              //   type: AggregationChartType.Investment,
                              // ),

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(children: [
                                  widget.investmentEntity.source
                                              ?.toLowerCase() !=
                                          "manual"
                                      ? Text(
                                          "Last Updated: ${getUpdatedDate()}",
                                          style: SubtitleHelper.h12.copyWith(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        )
                                      : const SizedBox(),
                                  detailsTile(
                                      label: "${translate!.policyNumber}:",
                                      value:
                                          widget.investmentEntity.policyNumber),
                                  detailsTile(
                                      label: "Withdrawal Value:",
                                      value:
                                          "${widget.investmentEntity.withdrawalValue?.currency} ${numberFormat1.format(widget.investmentEntity.withdrawalValue?.amount)}"),
                                  detailsTile(
                                      label: "General Transaction Amount:",
                                      value:
                                          "${widget.investmentEntity.generalTransactionValue?.currency} ${numberFormat1.format(widget.investmentEntity.generalTransactionValue?.amount)}"),
                                ]),
                              ),
                              isProvider || isHoxton
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        SizedBox(
                                            height: size.height * .8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * .5,
                                                  child: TabBar(
                                                    controller: _tabController,
                                                    tabs: tabsList,
                                                    indicatorWeight: 3,
                                                    indicatorColor:
                                                        appThemeColors?.primary,
                                                    unselectedLabelColor:
                                                        Colors.grey.shade700,
                                                    unselectedLabelStyle:
                                                        TitleHelper.h11,
                                                    labelStyle: TitleHelper.h11
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                    labelColor:
                                                        appThemeColors?.primary,
                                                  ),
                                                ),
                                                const Divider(
                                                    height: 0,
                                                    thickness: 1,
                                                    color: Colors.black26),
                                                Expanded(
                                                  child: TabBarView(
                                                    controller: _tabController,
                                                    children: tabBarViewList,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        );
                      } else if (state is YourInvestmentsError) {
                        return Center(
                          child: Text(state.errorMsg),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget investmentDataManual({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: SubtitleHelper.h11),
          Text(value, style: SubtitleHelper.h11),
        ],
      ),
    );
  }

  Widget listOfData(
      {required String name,
      required String units,
      required Function onTap,
      required bool isSelected,
      required String amount,
      required String perUnitsAmount}) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
              margin: const EdgeInsetsDirectional.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isSelected ? const Color(0xfffEAEBE1) : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 9.9,
                      spreadRadius: 0.5),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pop(context, data);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name.length > 14
                                        ? "${name.substring(0, 10)}..."
                                        : name,
                                    style: SubtitleHelper.h10
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    units == "0"
                                        ? ""
                                        : "$units ${translate!.units}",
                                    style: SubtitleHelper.h10.copyWith(
                                        color: appThemeColors!.disableText),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amount,
                            style: SubtitleHelper.h11
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              perUnitsAmount.trim() == "0"
                                  ? ""
                                  : "$perUnitsAmount ${translate!.perUnits}",
                              style: SubtitleHelper.h11.copyWith(
                                  color: appThemeColors!.disableText)),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ],
    );
  }

  Widget holdingTabView(var data) {
    final isManual = widget.investmentEntity.source!.toLowerCase() != "manual";
    final isHoxton = widget.investmentEntity.source!.toLowerCase() == "hoxton";
    if (isManual) {
      return Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          data.length <= 0
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("No data available"),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      itemCount: data.length,
                      itemBuilder: (con, index) {
                        final investments = data[index];
                        return listOfData(
                          isSelected: selectedId == investments.id,
                          onTap: () {
                            changeSelectedState(investments.id);
                          },
                          amount:
                              "${investments.value.currency} ${numberFormat.format(investments.value.amount)}",
                          name: investments.enrichedDescription.isEmpty
                              ? investments.description.isEmpty
                                  ? translate!.unknown
                                  : investments.description
                              : investments.enrichedDescription,
                          perUnitsAmount:
                              "${investments.price.currency} ${numberFormat.format(investments.price.amount)}",
                          units: "${investments.quantity}",
                        );
                      }),
                ),
        ],
      );
    } else if (isHoxton) {
      return SingleChildScrollView(
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            child: data.length <= 0
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text("No Data Available"),
                    ),
                  )
                : Column(
                    children: List.generate(data.length, (index) {
                      final pension = data[index];
                      return WedgeExpansionTile(
                        hideBottom: true,
                        index: index,
                        leftTitle: pension.description,
                        rightSubTitle: pension.price.amount <= 0
                            ? ""
                            : "${pension.price.currency} ${pension.price.amount} Per Unit",
                        rightTitle:
                            "${pension.value.currency} ${pension.value.amount}",
                        leftSubtitle: pension.quantity <= 0
                            ? ""
                            : "${pension.quantity} Unit",
                        midWidget: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "ISIN",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "Holding Type",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "Secondary Value",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "Book Cost",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "Percentage Growth",
                                    style: SubtitleHelper.h11,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    pension.isin,
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    pension.holdingType,
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "${pension.secondaryMarketValue.currency} ${numberFormat.format(pension.secondaryMarketValue.amount)}",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "${pension.costBasis.currency} ${numberFormat.format(pension.costBasis.amount)}",
                                    style: SubtitleHelper.h11,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  Text(
                                    "${pension.percentageGrowth}%",
                                    style: SubtitleHelper.h11,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget notesTabView() {
    String localStoredNotes = locator<SharedPreferences>()
            .getString("pensionNotes${widget.investmentEntity.id}") ??
        "";
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: TextFormField(
          maxLines: 1000,
          initialValue: widget.investmentEntity.notes,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Write notes here...",
            hintStyle: SubtitleHelper.h10.copyWith(
              color: Colors.grey,
            ),
          ),
          onChanged: (value) {
            //Edit note and save
            setState(() {
              widget.investmentEntity.notes = value;
            });
            notesUpdate = true;
            context.read<InvestmentNotesCubit>().editInvestmentNotesData({
              "body": {"notes": value},
              "id": widget.investmentEntity.id.toString()
            });
          },
        ));
  }

  Widget detailsTile({String? label, String? value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "$label",
          style: SubtitleHelper.h11.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "$value",
          style: SubtitleHelper.h11.copyWith(
              fontWeight: FontWeight.w600, color: appThemeColors?.primary),
        )
      ]),
    );
  }

  GestureDetector buildChartFilter(
      {required Function onTap,
      required String title,
      required bool isActive}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(title,
            style: SubtitleHelper.h11.copyWith(
                color: isActive ? Colors.black : appThemeColors!.disableDark)),
      ),
    );
  }
}
