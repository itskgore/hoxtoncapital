import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/stocks_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/features/all_accounts_types/presentation/pages/all_account_types.dart';
import 'package:wedge/features/assets/stocks/add_stcoks/presentation/pages/add_stocks_page.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/bloc/cubit/stocks_cubit.dart';
import 'package:wedge/features/assets/stocks/stocks_main/presentation/bloc/cubit/stocks_performance_state.dart';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/data_models/performence_chart_model.dart';
import '../../../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/shimmer_container.dart';
import '../../../../../../dependency_injection.dart';
import '../bloc/cubit/stocks_peformance_cubit.dart';

class StocksMainPage extends StatefulWidget {
  StocksMainPage({Key? key}) : super(key: key);

  @override
  _StocksMainPageState createState() => _StocksMainPageState();
}

class _StocksMainPageState extends State<StocksMainPage> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? translate;
  List pickedList = [];
  bool isCombineGraphData = true;
  String? selectedStockID;
  String searchInput = "";
  int? isSelected;
  String? selectedTileTitle;
  String? selectedStocksCreatedAt;
  String? createdAt;
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);

  @override
  void initState() {
    // TODO: implement initState
    context.read<StocksCubit>().getData();
    getGraphData(
        isFiltered: false,
        fromDate: dateFormatter5
            .format(DateTime.now().subtract(const Duration(days: 30))),
        toDate: dateFormatter5.format(DateTime.now()),
        assetType: "stocksBonds");
    _scrollController.addListener(() {});
    super.initState();
  }

  addStocks(List<StocksAndBondsEntity> stocks) async {
    var data;
    if (stocks.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddStocksPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => AddStocksPage()));
    }
    if (data != null) {
      context.read<StocksCubit>().getData();
    }
  }

  getGraphData(
      {required String fromDate,
      required String toDate,
      String? assetType,
      required bool isFiltered,
      String? id}) {
    // get Chart Data
    context.read<StocksPerformanceCubit>().getStocksPerformanceData(
        merge: true,
        scope: ["fi"],
        isFiltered: isFiltered,
        fromDate: fromDate,
        combinedGraph: isCombineGraphData,
        toDate: toDate,
        assetType: assetType,
        id: id);
  }

  loadGraphData(
      {var data, required List<PerformanceChartModel> chartData}) async {
    if (data.length > 1) {
      chartData.clear();
      for (var i = 1; i < data.length; i++) {
        String dateUtc =
            DateTime.fromMillisecondsSinceEpoch(data[i].first * 1000)
                .toString();
        DateTime date = DateTime.parse(dateUtc);
        if (isCombineGraphData) {
          chartData
              .add(PerformanceChartModel(date, double.parse("${data[i][2]}")));
        } else {
          chartData
              .add(PerformanceChartModel(date, double.parse("${data[i][6]}")));
        }
      }
      chartData.sort((a, b) {
        DateTime aDate = a.date;
        DateTime bDate = b.date;
        return aDate.compareTo(bDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);

    final List<PerformanceChartModel> chartData = [];
    DateTime currentDate = DateTime.now();
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    DateTime endDate = currentDate;
    return BlocConsumer<StocksCubit, StocksState>(
      listener: (context, state) {
        if (state is StocksLoaded) {
          if (state.deleteMessageSent) {
            setState(() {
              isDeleting = false;
            });
            showSnackBar(context: context, title: translate!.assetDeleted);
            setState(() {});
          }
        }
        if (state is StocksError) {
          setState(() {
            isDeleting = false;
          });

          showSnackBar(context: context, title: state.errorMsg);
        }
      },
      builder: (context, state) {
        if (state is StocksLoaded) {
          var stacksList = state.assets.stocksBonds;
          return WillPopScope(
            onWillPop: () async {
              // refreshMainState(context: context, isAsset: true);
              return true;
            },
            child: Scaffold(
              backgroundColor: appThemeColors!.bg,
              appBar: wedgeAppBar(
                  context: context,
                  title: translate!.stocksBonds,
                  leadingIcon: getLeadingIcon(context, true),
                  actions: IconButton(
                      onPressed: () async {
                        addStocks(stacksList);
                      },
                      icon: const Icon(Icons.add))),
              body: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(kpadding),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: lastDayPerformance,
                          builder: (context, value, child) {
                            return DashboardValueContainer(
                                mainValue:
                                    "${state.assets.summary.stocksBonds.currency} ${state.assets.summary.stocksBonds.amount}",
                                mainTitle: translate!.totalStocksbondsValue,
                                leftValue: "${stacksList.length}",
                                leftTitle: stacksList.length == 1
                                    ? translate!.stockBond
                                    : translate!.stocksBonds,
                                rightTitle: translate!.bonds,
                                summary: value,
                                isSingleTitle: true,
                                leftImage:
                                    "assets/icons/stockbondsMainContainer.png",
                                rightvalue:
                                    "${state.assets.summary.stocksBonds.countryCount}");
                          }),
                      BlocConsumer<StocksPerformanceCubit,
                          StocksPerformanceState>(
                        listener: (context, state) {
                          if (state is StocksPerformanceError) {
                            showSnackBar(
                                context: context, title: state.errorMsg);
                          }
                          if (state is StocksPerformanceLoaded) {
                            lastDayPerformance.value = isCombineGraphData
                                ? state.pensionPerformanceModel.merge?.fi
                                    ?.lastDayPerformanceSummary
                                : state.pensionPerformanceModel.merge?.fi
                                    ?.lastDayPerformance;
                            log("Listener Called! data: ${lastDayPerformance.value}");
                          }
                        },
                        builder: (context, state) {
                          if (state is StocksPerformanceLoading) {
                            // return Center(
                            //   child: buildCircularProgressIndicator(),
                            // );
                            double height = size.height;
                            double chartHeight = height < 700
                                ? height * 0.4
                                : height < 800
                                    ? height * .4
                                    : height * 0.3;
                            return CustomShimmerContainer(
                              height: chartHeight,
                            );
                          } else if (state is StocksPerformanceLoaded) {
                            var data = [];
                            if (state.pensionPerformanceModel.merge!.fi !=
                                null) {
                              if (isCombineGraphData) {
                                data = state.pensionPerformanceModel.merge!.fi!
                                    .performanceSummary!;
                              } else {
                                data = state.pensionPerformanceModel.merge!.fi!
                                    .performance!;
                              }
                            }
                            // loadGraphData(data: data, chartData: chartData);

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    DurationSelectorBottomSheet(
                                      startDate: startDate,
                                      endDate: endDate,
                                      isShowMax: true,
                                      createdAt: isCombineGraphData
                                          ? DateTime.parse("2022-01-01")
                                              .toString()
                                          : DateTime.parse(
                                                  "$selectedStocksCreatedAt")
                                              .toLocal()
                                              .toString(),
                                      initDateList: pickedList,
                                      onChange: (dates) {
                                        var fromDate =
                                            dateFormatter5.format(dates![0]!);
                                        var toDate =
                                            dateFormatter5.format(dates[1]!);
                                        isCombineGraphData
                                            ? getGraphData(
                                                fromDate: fromDate,
                                                isFiltered: true,
                                                toDate: toDate,
                                                assetType: "stocksBonds")
                                            : getGraphData(
                                                fromDate: fromDate,
                                                isFiltered: true,
                                                toDate: toDate,
                                                id: selectedStockID);
                                        setState(() {
                                          pickedList = dates!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                    width: size.width,
                                    height: size.height * .25,
                                    child: WedgeEcharts(
                                        isFiltered: state.isFiltered,
                                        currency: state.baseCurrency,
                                        index: isCombineGraphData ? 2 : 6,
                                        data: state.data))
                              ],
                            );
                          } else if (state is StocksPerformanceError) {
                            return Center(
                              child: Text(state.errorMsg),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: Text(
                              isCombineGraphData
                                  ? translate!.overallPerformance
                                  : "$selectedTileTitle",
                              style: TitleHelper.h11),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${translate!.holdings} (${stacksList.length})",
                                style: TitleHelper.h9),
                            AppButton(
                                label: translate!.add,
                                onTap: () async {
                                  addStocks(stacksList);
                                }),
                          ],
                        ),
                      ),

                      ///SearchBar
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 9.9,
                                spreadRadius: 0.5),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchInput = value;
                            });
                          },
                          // controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search by name",
                            hintStyle: SubtitleHelper.h11
                                .copyWith(color: Colors.black38),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            prefixIcon: const Icon(Icons.search),
                          ),
                        ),
                      ),

                      /// Holding List
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final StocksAndBondsEntity item =
                                stacksList.removeAt(oldIndex);
                            stacksList.insert(newIndex, item);
                          });
                        },
                        children: stacksList
                                .where((element) => element.name
                                    .toLowerCase()
                                    .startsWith(searchInput.toLowerCase()))
                                .isEmpty
                            ? [
                                Container(
                                    key: const ValueKey("element.name"),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(translate!.noDataFound,
                                          style: TitleHelper.h10),
                                    )))
                              ]
                            : stacksList.map((item) {
                                final index = stacksList.indexOf(item);
                                return Container(
                                  key: ValueKey(item),
                                  child: item.name
                                          .toLowerCase()
                                          .startsWith(searchInput.toLowerCase())
                                      ? _exptiles(
                                          data: item,
                                          index: index,
                                          onExpend: (isExpanded) {
                                            _scrollController.animateTo(
                                              0,
                                              duration: const Duration(
                                                  milliseconds: 800),
                                              curve: Curves.easeInOut,
                                            );

                                            if (!isExpanded) {
                                              setState(() {
                                                isCombineGraphData = true;
                                              });
                                              isSelected = null;
                                              getGraphData(
                                                  fromDate: Jiffy.now()
                                                      .subtract(months: 1)
                                                      .dateTime
                                                      .toLocal()
                                                      .toString(),
                                                  isFiltered: true,
                                                  toDate:
                                                      DateTime.now().toString(),
                                                  assetType: "stocksBonds");
                                            } else {
                                              setState(() {
                                                isCombineGraphData = false;
                                              });
                                              isSelected = 0;
                                              getGraphData(
                                                  fromDate: Jiffy.now()
                                                      .subtract(months: 1)
                                                      .dateTime
                                                      .toString(),
                                                  isFiltered: true,
                                                  toDate: DateTime.now()
                                                      .toLocal()
                                                      .toString(),
                                                  id: item.id);
                                            }

                                            setState(() {
                                              stacksList.remove(item);
                                              stacksList.insert(0, item);
                                              // Extension Handling
                                            });
                                            selectedStockID = item.id;
                                            selectedTileTitle = item.name;
                                            selectedStocksCreatedAt =
                                                item.createdAt;
                                          })
                                      : null,
                                );
                              }).toList(),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // AddNewButton(
                      //     text: translate!.addNewStockBond,
                      //     onTap: () async {
                      //       addStocks(stacksList);
                      //     })
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: FooterButton(
                text: translate!.addOtherAssets,
                onTap: () {
                  // refreshMainState(context: context, isAsset: true);
                  Navigator.pop(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) =>
                              const AllAccountTypes()));
                },
              ),
            ),
          );
        } else {
          return Scaffold(
            body: const Center(
              child: CircularProgressIndicator(),
            ),
            bottomNavigationBar: FooterButton(
              text: translate!.addOtherAssets,
              onTap: () {
                // refreshMainState(context: context, isAsset: true);
                Navigator.pop(
                    context,
                    CupertinoPageRoute(
                        builder: (BuildContext context) =>
                            const AllAccountTypes()));
              },
            ),
          );
        }
      },
    );
  }

  bool isDeleting = false;

  Widget _exptiles(
      {required StocksAndBondsEntity data,
      required int index,
      Function? onExpend}) {
    return WedgeExpansionTile(
      key: Key(index.toString()),
      index: index,
      isOpen: isSelected,
      onTab: (isExpanded) {
        onExpend!(isExpanded);
      },
      leftSubtitle: '${translate!.units} : ${data.quantity}',
      leftTitle: data.name,
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
                        setState(() {
                          isDeleting = true;
                        });
                        showSnackBar(
                            context: context,
                            title: translate!.loading,
                            duration: const Duration(minutes: 3));

                        context.read<StocksCubit>().deletestocksBonds(data.id);
                        Navigator.pop(context);
                      },
                      deniedPress: () {
                        Navigator.pop(context);
                      },
                      acceptText: translate!.yesDelete,
                      deniedText: translate!.noiWillKeepIt));
            },
      onEditPressed: () async {
        var result = await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => AddStocksPage(
                      assetData: data,
                    )));
        if (result != null) {
          context.read<StocksCubit>().getData();
        }
      },
      rightTitle: '${data.value.currency} ${data.value.amount}',
    );
  }
}
