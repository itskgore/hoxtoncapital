import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/your_pensions/presentation/cubit/your_pensions_cubit.dart';

import '../../../../core/common/functions/common_functions.dart';
import '../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../core/contants/enums.dart';
import '../../../../core/data_models/performence_chart_model.dart';
import '../../../../core/utils/reconnect_aggregator.dart';
import '../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../core/utils/wedge_func_methods.dart';
import '../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../core/widgets/custom_assets_showcase.dart';
import '../../../../core/widgets/shimmer_container.dart';
import '../../../../core/widgets/wedge_expension_tile.dart';
import '../../../assets/pension/pension_main/presentation/bloc/pensionmaincubit_cubit.dart';
import '../cubit/pension_notes_cubit.dart';
import '../cubit/your_pension_peformance_cubit.dart';
import '../cubit/your_pension_performance_state.dart';

class YourPensionsMain extends StatefulWidget {
  final PensionsEntity pensionsEntity;

  const YourPensionsMain({Key? key, required this.pensionsEntity}) : super(key: key);

  @override
  State<YourPensionsMain> createState() => _YourPensionsMainState();
}

class _YourPensionsMainState extends State<YourPensionsMain>
    with TickerProviderStateMixin {
  AppLocalizations? translate;
  bool isDeletingAccount = false;
  bool notesUpdate = false;
  String selectedId = "";
  bool isEdited = false;
  List pickedList = [];
  late TabController _tabController;
  final GlobalKey _showcaseKey = GlobalKey();
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);

  @override
  void initState() {
    //Tabs
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    //
    context.read<YourPensionsCubit>().getPensions(
        widget.pensionsEntity.aggregatorId.toString(),
        widget.pensionsEntity.source.toString());

    // get Chart Data
    context.read<YourPensionPerformanceCubit>().getPensionPerformanceData(
        merge: true,
        isFiltered: false,
        scope: ["fi"],
        fromDate:
            dateFormatter5.format(Jiffy.now().subtract(months: 1).dateTime),
        toDate: dateFormatter5.format(DateTime.now()),
        id: widget.pensionsEntity.id.toString());
    //

    super.initState();
  }

  // fromDate: dateFormatter5.format(DateTime.now()),
  // toDate: dateFormatter5
  //     .format(DateTime.now().subtract(const Duration(days: 30))),

  String getBalance() {
    // if (widget.pensionsEntity.source.toLowerCase() != "manual") {
    //   return "${widget.pensionsEntity.currentValue.currency} ${widget.pensionsEntity.contributionTotalAmount.amount}";
    // } else {
    //   return "${widget.pensionsEntity.currentValue.currency} ${widget.pensionsEntity.contributionTotalAmount.amount}";
    // }

    if (widget.pensionsEntity.pensionType == "Defined Contribution") {
      return "${widget.pensionsEntity.currentValue.currency} ${widget.pensionsEntity.currentValue.amount}";
    } else {
      return "${widget.pensionsEntity.annualIncomeAfterRetirement.currency} ${widget.pensionsEntity.annualIncomeAfterRetirement.amount}";
    }
  }

  changeSelectedState(String id) {
    setState(() {
      selectedId = id;
    });
  }

  removePension(String id) {
    locator.get<WedgeDialog>().confirm(
        context,
        WedgeConfirmDialog(
            title: translate!.areYouSure,
            subtitle: widget.pensionsEntity.source.toLowerCase() ==
                    AggregatorProvider.Saltedge.name.toLowerCase()
                ? translate!.saltEdgeDeleteConfirmation
                : translate!.yodleeDeleteConfirmation,
            acceptedPress: () {
              setState(() {
                isDeletingAccount = true;
              });
              showSnackBar(context: context, title: "Loading....");
              context.read<YourPensionsCubit>().deletePensionData(id);
              context.read<PensionMaincubitCubit>().getPensionsData();

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
        DateTime? date;
        if (data[i].first is DateTime) {
          date = data[i].first;
        } else {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(data[i].first * 1000);
        }
        chartData
            .add(PerformanceChartModel(date!, double.parse("${data[i][6]}")));
      }
      chartData.sort((a, b) {
        DateTime aDate = a.date;
        DateTime bDate = b.date;
        return aDate.compareTo(bDate);
      });
    }
  }

  getUpdatedDate() {
    return (widget.pensionsEntity.aggregator?.lastUpdatedDate != "" &&
            widget.pensionsEntity.aggregator?.lastUpdatedDate != null)
        ? dateFormatter12.format(
            DateTime.parse(widget.pensionsEntity.aggregator!.lastUpdatedDate!))
        : (widget.pensionsEntity.updatedAt != ""
            ? dateFormatter12
                .format(DateTime.parse(widget.pensionsEntity.updatedAt))
            : dateFormatter12
                .format(DateTime.parse(widget.pensionsEntity.createdAt)));
  }

  getUpdatedDateRange() {
    if (widget.pensionsEntity.aggregator?.createdDate != null &&
        widget.pensionsEntity.aggregator?.createdDate != "") {
      return widget.pensionsEntity.aggregator?.createdDate;
    } else {
      return widget.pensionsEntity.createdAt;
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
  //     String providerAccountId = widget.pensionsEntity.aggregatorId.toString();
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
  //       .refreshAggregator(widget.pensionsEntity);
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

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    final List<PerformanceChartModel> chartData = [];
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    DateTime endDate = currentDate;

    bool showTooltip =
        widget.pensionsEntity.source?.toLowerCase() != 'hoxton' &&
            DateTime.parse(widget.pensionsEntity.createdAt)
                    .toLocal()
                    .difference(DateTime.now())
                    .inDays
                    .abs() <
                7;
    bool isExpired = isAggregatorExpired(data: widget.pensionsEntity);

    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
          context: context,
          title: translate!.pensions,
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
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back))),
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
                      mainTitle: translate!.pensionAccountBalance,
                      leftImage: "",
                      showOnlyTop: true,
                      leftValue: "",
                      leftTitle: "",
                      rightTitle: "",
                      rightvalue: "");
                },
              ),
              ListTile(
                leading: widget.pensionsEntity.source.toLowerCase() ==
                            "hoxton" ||
                        widget.pensionsEntity.source.toLowerCase() != "manual"
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              'assets/icons/persoanlLoanMainContainer.png',
                          image: widget.pensionsEntity.aggregatorLogo,
                          height: 40,
                          width: 40,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/icons/persoanlLoanMainContainer.png",
                              height: 40,
                              width: 40,
                            );
                          },
                        ),
                      )
                    : Image.asset(
                        "assets/icons/persoanlLoanMainContainer.png",
                        height: 40,
                        width: 40,
                      ),
                title: Text(
                    widget.pensionsEntity.name.length > 30
                        ? "${widget.pensionsEntity.name.substring(0, 20)}..."
                        : widget.pensionsEntity.name,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TitleHelper.h10),
                subtitle: Text(widget.pensionsEntity.pensionType,
                    style: SubtitleHelper.h11
                        .copyWith(fontStyle: FontStyle.italic)),
                trailing: widget.pensionsEntity.source.toLowerCase() == 'hoxton'
                    ? null
                    : ShowcaseContainer(
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
                                  offset: Offset(0, 50),
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
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          height: 28,
                                          padding: EdgeInsets.zero,
                                          value: 1,
                                          onTap: () {
                                            // _aggregatorReconnect
                                            ReconnectAggregator
                                                .aggregatorReconnect(
                                                    dataEntity:
                                                        widget.pensionsEntity,
                                                    mounted: mounted);
                                          },
                                          child: Container(
                                              child: popUpItem(
                                                  translate!.reconnect)),
                                        ),
                                        PopupMenuItem(
                                          height: 28,
                                          padding: EdgeInsets.zero,
                                          value: 2,
                                          onTap: () {
                                            removePension(
                                                widget.pensionsEntity.id);
                                          },
                                          child: popUpItem(
                                            translate!.unlinkAccount,
                                          ),
                                        ),
                                      ]),
                            ],
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              widget.pensionsEntity.source.toLowerCase() != "manual"
                  ? BlocConsumer<YourPensionPerformanceCubit,
                      YourPensionsPerformanceState>(
                      listener: (context, state) {
                        if (state is YourPensionsPerformanceError) {
                          showSnackBar(context: context, title: state.errorMsg);
                        }
                        if (state is YourPensionPerformanceLoaded) {
                          lastDayPerformance.value = state
                              .pensionPerformanceModel
                              .merge
                              ?.fi
                              ?.lastDayPerformance;
                        }
                      },
                      builder: (context, state) {
                        //: Loading
                        if (state is YourPensionsPerformanceLoading) {
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
                        else if (state is YourPensionPerformanceLoaded) {
                          var newData = state.pensionPerformanceModel;
                          var data =
                              state.pensionPerformanceModel.merge!.fi != null
                                  ? state.pensionPerformanceModel.merge!.fi!
                                      .performance!
                                  : [];
                          // loadGraphData(data: data, chartData: chartData);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DurationSelectorBottomSheet(
                                      startDate: startDate,
                                      endDate: endDate,
                                      isShowMax: true,
                                      createdAt: getUpdatedDateRange(),
                                      initDateList: pickedList,
                                      onChange: (dates) {
                                        var fromDate =
                                            dateFormatter5.format(dates![0]!);
                                        var toDate =
                                            dateFormatter5.format(dates[1]!);
                                        context
                                            .read<YourPensionPerformanceCubit>()
                                            .getPensionPerformanceData(
                                                merge: true,
                                                isFiltered: true,
                                                scope: ["fi"],
                                                fromDate: fromDate,
                                                toDate: toDate,
                                                id: widget.pensionsEntity.id
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
                                      width: double.infinity,
                                      height: size.height * .25,
                                      child: data.isNotEmpty
                                          ? WedgeEcharts(
                                              isFiltered: state.isFiltered,
                                              currency: data[0][5],
                                              data: data)
                                          : null,
                                    ),
                                    showTooltip
                                        ? Positioned(
                                            bottom: 80,
                                            left: 46,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                color: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    width: 0.50,
                                                    color: Color(0xFFCFCFCF),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
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
                                                      'Stay tuned. The pension graph will start filling up in a few days as we gather more data.',
                                                      style: SubtitleHelper.h11
                                                          .copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
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
                        else if (state is YourPensionsPerformanceError) {
                          return Center(
                            child: Text(state.errorMsg),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  : const SizedBox(),
              BlocConsumer<YourPensionsCubit, YourPensionsState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is YourPensionsLoaded) {
                    if (state.isDeletePerformed) {
                      Navigator.pop(context, true);
                      showSnackBar(
                          context: context,
                          title: translate!.investmentDeleted);
                    }
                  }
                  if (state is YourPensionsError) {
                    showSnackBar(context: context, title: state.errorMsg);
                  }
                },
                builder: (context, state) {
                  final isProvider =
                      widget.pensionsEntity.source.toLowerCase() != 'manual' &&
                          widget.pensionsEntity.source.toLowerCase() !=
                              'hoxton';
                  final isHoxton =
                      widget.pensionsEntity.source.toLowerCase() == "hoxton";
                  if (state is YourPensionsLoading) {
                    return Center(
                      child: buildCircularProgressIndicator(),
                    );
                  } else if (state is YourPensionsLoaded) {
                    final data = state.investmentHoldingsEntity;
                    List<Widget> tabsList = [
                      Tab(
                        child:
                            Text(translate!.holdings, style: TitleHelper.h11),
                      ),
                      Tab(
                        child: Text(translate!.notes, style: TitleHelper.h11),
                      ),
                    ];
                    List<Widget> tabBarViewList = [
                      holdingTabView(data),
                      notesTabView(),
                    ];
                    // chalking data list have data or no if yes show holdings tab
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                widget.pensionsEntity.source.toLowerCase() !=
                                        "manual"
                                    ? widget.pensionsEntity.updatedAt != ""
                                        ? Text(
                                            "Last Updated: ${getUpdatedDate()}",
                                            style: SubtitleHelper.h12.copyWith(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        : const SizedBox()
                                    : const SizedBox(),
                                detailsTile(
                                    label: "${translate!.policyNumber}:",
                                    value: widget.pensionsEntity.policyNumber),
                                detailsTile(
                                    label: "Withdrawal Value:",
                                    value:
                                        "${widget.pensionsEntity.withdrawalValue.currency} ${numberFormat1.format(widget.pensionsEntity.withdrawalValue.amount)}"),
                                detailsTile(
                                    label: "General Transaction Amount:",
                                    value:
                                        "${widget.pensionsEntity.generalTransactionValue.currency} ${numberFormat1.format(widget.pensionsEntity.generalTransactionValue.amount)}"),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              isProvider || isHoxton
                                  ? SizedBox(
                                      height: size.height * .7,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width * .5,
                                            child: TabBar(
                                              controller: _tabController,
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
                                                          FontWeight.w900),
                                              labelColor:
                                                  appThemeColors?.primary,
                                              tabs: tabsList,
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
                                      ))
                                  : const SizedBox(),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else if (state is YourPensionsError) {
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
    );
  }

  Widget holdingTabView(var data) {
    // final isYodlee = widget.pensionsEntity.source.toLowerCase() == "yodlee";
    final isHoxton = widget.pensionsEntity.source.toLowerCase() == "hoxton";
    final isProvider = widget.pensionsEntity.source.toLowerCase() != 'manual' &&
        widget.pensionsEntity.source.toLowerCase() != 'hoxton';
    if (isProvider) {
      return const Column(
        children: [
          // Container(
          //   height: 350,
          //   child: ListView.builder(
          //       itemCount: data.length,
          //       itemBuilder: (con, index) {
          //         final investments = data[index];
          //         return listOfData(
          //           isSelected:
          //               selectedId == investments.id,
          //           onTap: () {
          //             changeSelectedState(
          //                 investments.id);
          //           },
          //           amount:
          //               "${investments.value.currency} ${numberFormat.format(investments.value.amount)}",
          //           name: investments
          //                   .enrichedDescription
          //                   .isEmpty
          //               ? investments
          //                       .description.isEmpty
          //                   ? translate!.unknown
          //                   : "${investments.description}"
          //               : "${investments.enrichedDescription}",
          //           perUnitsAmount:
          //               "${investments.price.currency} ${numberFormat.format(investments.price.amount)}",
          //           units: "${investments.quantity}",
          //         );
          //       }),
          // ),
        ],
      );
    } else if (isHoxton) {
      return SingleChildScrollView(
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
                      // rightSubTitle: pension.price.amount <= 0
                      //     ? ""
                      //     : "${pension.price.currency} ${pension.price.amount} Per Unit",
                      rightSubTitle:
                          "${pension.value.currency} ${pension.value.amount}",
                      rightSubtitleStyle: TitleHelper.h10,
                      // leftSubtitle: pension.quantity <= 0
                      //     ? ""
                      //     : "${pension.quantity} Unit",
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
                                  ]),
                            ]),
                      ),
                    );
                  }),
                ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget notesTabView() {
    String localStoredNotes = locator<SharedPreferences>()
            .getString("pensionNotes${widget.pensionsEntity.id}") ??
        "";
    return Container(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: TextFormField(
          maxLines: 1000,
          initialValue: widget.pensionsEntity.notes,
          decoration: InputDecoration(
            hintText: "Write notes here...",
            hintStyle: SubtitleHelper.h10.copyWith(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // locator<SharedPreferences>()
            //     .setString("pensionNotes${widget.pensionsEntity.id}", value);
            //Edit note and save
            final body = {
              "body": {"notes": value},
              "id": widget.pensionsEntity.id.toString()
            };
            setState(() {
              widget.pensionsEntity.notes = value;
            });
            notesUpdate = true;
            context.read<PensionNotesCubit>().editPensionNotesData(body);
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

  Widget investmentDataManual({required String title, required String value}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: SubtitleHelper.h11,
          ),
          Text(
            value,
            style: SubtitleHelper.h11,
          ),
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
                                    name,
                                    style: SubtitleHelper.h11.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    units == "0"
                                        ? ""
                                        : "$units ${translate!.units}",
                                    style: SubtitleHelper.h11.copyWith(
                                        color: appThemeColors!.disableDark),
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
                          Text(amount,
                              style: SubtitleHelper.h11
                                  .copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                              perUnitsAmount == "0"
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

  Widget popUpItem(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          textAlign: TextAlign.left,
          style: SubtitleHelper.h10.copyWith(color: color),
          // TextStyle(color: appThemeColors!.textDark).copyWith(color: color),
        ),
      ),
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
                color: isActive ? Colors.black : appThemeColors!.disableText)),
      ),
    );
  }
}
