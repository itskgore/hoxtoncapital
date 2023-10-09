import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/buttons/footer_single_button.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/wedge_echarts.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/presentation/pages/add_crypto_manual_page.dart';
import 'package:wedge/features/assets/crypto/crypto_main/presentation/bloc/main_crypto_bloc_cubit.dart';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/data_models/performence_chart_model.dart';
import '../../../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/dialog/wedge_comfirm_dialog.dart';
import '../../../../../../core/widgets/shimmer_container.dart';
import '../bloc/crypto_peformance_cubit.dart';
import '../bloc/crypto_performance_state.dart';

class CryptoMainPage extends StatefulWidget {
  const CryptoMainPage({Key? key}) : super(key: key);

  @override
  _CryptoMainPageState createState() => _CryptoMainPageState();
}

class _CryptoMainPageState extends State<CryptoMainPage> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? translate;
  List pickedList = [];
  bool isCombineGraphData = true;
  String? selectedStockID;
  String searchInput = "";
  String? selectedTileTitle;
  int? isSelected;
  String? selectedStocksCreatedAt;
  final lastDayPerformance = ValueNotifier<LastDayPerformance?>(null);

  @override
  void initState() {
    // TODO: implement initState
    context.read<MainCryptoBlocCubit>().getCryptoCurrencies();
    getGraphData(
        fromDate: dateFormatter5
            .format(DateTime.now().subtract(const Duration(days: 30))),
        toDate: dateFormatter5.format(DateTime.now()),
        isFiltered: false,
        assetType: "cryptoCurrency");
    _scrollController.addListener(() {});
    super.initState();
  }

  getGraphData(
      {required String fromDate,
      required String toDate,
      required bool isFiltered,
      String? assetType,
      String? id}) {
    // get Chart Data
    context.read<CryptoPerformanceCubit>().getCryptoPerformanceData(
        merge: true,
        scope: ["fi"],
        isFiltered: isFiltered,
        combinedGraph: isCombineGraphData,
        fromDate: fromDate,
        toDate: toDate,
        assetType: assetType,
        id: id);
  }

  loadGraphData(
      {var data, required List<PerformanceChartModel> chartData}) async {
    chartData.clear();
    if (data.length > 1) {
      for (var i = 1; i < data.length; i++) {
        DateTime date = data[i].first;
        if (isCombineGraphData) {
          chartData.add(PerformanceChartModel(
              date.toLocal(), double.parse("${data[i][2]}")));
        } else {
          chartData.add(PerformanceChartModel(
              date.toLocal(), double.parse("${data[i][6]}")));
        }
      }
      chartData.sort((a, b) {
        DateTime aDate = a.date;
        DateTime bDate = b.date;
        return aDate.compareTo(bDate);
      });
    }
  }

  addCrypto(List<CryptoCurrenciesEntity> cryptoCurrencies) async {
    var data;
    if (cryptoCurrencies.isEmpty) {
      data = await Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => const AddCryptoManualPage()));
    } else {
      data = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => const AddCryptoManualPage()));
    }
    if (data != null) {
      context.read<MainCryptoBlocCubit>().getCryptoCurrencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<PerformanceChartModel> chartData = [];
    translate = translateStrings(context);

    DateTime currentDate = DateTime.now();
    DateTime startDate =
        DateTime(currentDate.year, currentDate.month - 1, currentDate.day);
    DateTime endDate = currentDate;
    return WillPopScope(
      onWillPop: () async {
        // refreshMainState(context: context, isAsset: true);
        return true;
      },
      child: Scaffold(
        backgroundColor: appThemeColors!.bg,
        appBar: wedgeAppBar(
            context: context,
            title: translate!.cryptos,
            leadingIcon: getLeadingIcon(context, true),
            actions: IconButton(
                onPressed: () async {
                  addCrypto(
                      RootApplicationAccess.assetsEntity?.cryptoCurrencies ??
                          []);
                },
                icon: const Icon(Icons.add))),
        body: BlocConsumer<MainCryptoBlocCubit, MainCryptoBlocState>(
          listener: (context, state) {
            if (state is MainCryptoBlocError) {
              // show error snack
              setState(() {
                isDeleting = false;
              });
              showSnackBar(context: context, title: state.errorMsg);
            } else if (state is MainCryptoBlocLoaded) {
              if (state.showDeleteMsg) {
                // show delete snack
                showSnackBar(context: context, title: translate!.crytoDeleted);
                setState(() {
                  isDeleting = false;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is MainCryptoBlocLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is MainCryptoBlocLoaded) {
              var cryptoList = state.data.cryptoCurrencies;
              return SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ValueListenableBuilder(
                        valueListenable: lastDayPerformance,
                        builder: (context, value, child) {
                          return DashboardValueContainer(
                            isSingleTitle: true,
                            mainValue:
                                "${state.data.summary.cryptoCurrencies.currency} ${state.data.summary.cryptoCurrencies.amount}",
                            mainTitle: translate!.totalCryptoCurrencyValue,
                            leftValue: "${cryptoList.length}",
                            leftTitle: cryptoList.length == 1
                                ? translate!.cryptoCurrency
                                : translate!.cryptoCurrencies,
                            rightTitle: translate!.exchanges,
                            rightvalue:
                                "${state.data.summary.cryptoCurrencies.countryCount}",
                            summary: value,
                          );
                        },
                      ),
                      BlocConsumer<CryptoPerformanceCubit,
                          CryptoPerformanceState>(
                        listener: (context, state) {
                          if (state is CryptoPerformanceError) {
                            showSnackBar(
                                context: context, title: state.errorMsg);
                          }
                          if (state is CryptoPerformanceLoaded) {
                            lastDayPerformance.value = isCombineGraphData
                                ? state.pensionPerformanceModel.merge?.fi
                                    ?.lastDayPerformanceSummary
                                : state.pensionPerformanceModel.merge?.fi
                                    ?.lastDayPerformance;
                            log("Listener Called! data: ${lastDayPerformance.value?.diff}");
                          }
                        },
                        builder: (context, state) {
                          if (state is CryptoPerformanceLoading) {
                            double height = size.height;
                            double chartHeight = height < 700
                                ? height * 0.4
                                : height < 800
                                    ? height * .4
                                    : height * 0.3;

                            return CustomShimmerContainer(
                              height: chartHeight,
                            );
                          } else if (state is CryptoPerformanceLoaded) {
                            var data;
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
                            loadGraphData(data: data, chartData: chartData);
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
                                                toDate: toDate,
                                                isFiltered: true,
                                                assetType: "cryptoCurrency")
                                            : getGraphData(
                                                isFiltered: true,
                                                fromDate: fromDate,
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
                                      data: state.data,
                                      currency: state.baseCurrency,
                                      isFiltered: false,
                                      index: isCombineGraphData ? 2 : 6,
                                    ))
                                // PerformanceChart(
                                //   chartData: chartData,
                                //   lineColors: isCombineGraphData
                                //       ? Colors.blue.shade800
                                //       : Colors.orange.shade800,
                                //   currencyType: isCombineGraphData
                                //       ? state.pensionPerformanceModel.merge?.fi
                                //           ?.baseCurrency
                                //       : (data.length > 1
                                //           ? data[1][5]
                                //           : state.pensionPerformanceModel.merge
                                //               ?.fi?.baseCurrency),
                                // ),
                              ],
                            );
                          } else if (state is CryptoPerformanceError) {
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
                                "${translate!.holdings} (${cryptoList.length})",
                                style: TitleHelper.h9),
                            AppButton(
                                label: translate!.add,
                                onTap: () async {
                                  addCrypto(state.data.cryptoCurrencies);
                                }),
                          ],
                        ),
                      ),

                      ///searchBar
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
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final CryptoCurrenciesEntity item =
                                cryptoList.removeAt(oldIndex);
                            cryptoList.insert(newIndex, item);
                          });
                        },
                        //state.data.cryptoCurrencies
                        children: cryptoList
                                .where((element) => element.name
                                    .toLowerCase()
                                    .startsWith(searchInput.toLowerCase()))
                                .isEmpty
                            ? [
                                Container(
                                    key: const ValueKey("NoDataFoundKey"),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(translate!.noDataFound,
                                          style: TitleHelper.h10),
                                    )))
                              ]
                            : cryptoList.map((item) {
                                final index = cryptoList.indexOf(item);
                                return Container(
                                  key: ValueKey(item),
                                  child: item.name
                                          .toLowerCase()
                                          .startsWith(searchInput.toLowerCase())
                                      ? _exptiles(
                                          index: index,
                                          data: item,
                                          onExpend: (isExpanded) {
                                            // isTileExpended = isExpanded;
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
                                                  fromDate: DateTime.now()
                                                      .subtract(const Duration(
                                                          days: 30))
                                                      .toString(),
                                                  isFiltered: true,
                                                  toDate:
                                                      DateTime.now().toString(),
                                                  assetType: "cryptoCurrency");
                                            } else {
                                              setState(() {
                                                isCombineGraphData = false;
                                              });
                                              isSelected = 0;
                                              getGraphData(
                                                  isFiltered: true,
                                                  fromDate: DateTime.now()
                                                      .subtract(const Duration(
                                                          days: 30))
                                                      .toString(),
                                                  toDate:
                                                      DateTime.now().toString(),
                                                  id: item.id);
                                            }
                                            setState(() {
                                              cryptoList.remove(item);
                                              cryptoList.insert(0, item);
                                            });
                                            selectedTileTitle = item.name;
                                            selectedStockID = item.id;
                                            selectedStocksCreatedAt =
                                                item.createdAt;
                                          })
                                      : const SizedBox(),
                                );
                              }).toList(),
                      ),
                      // const SizedBox(
                      //   height: 20,
                      // ),
                      // AddNewButton(
                      //     text: translate!.addNewCryptoCurrency,
                      //     onTap: () async {
                      //       addCrypto(state.data.cryptoCurrencies);
                      //     })
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: FooterButton(
          text: translate!.addOtherAssets,
          onTap: () {
            // refreshMainState(context: context, isAsset: true);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  bool isDeleting = false;

  Widget _exptiles(
      {required CryptoCurrenciesEntity data,
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
                        context
                            .read<MainCryptoBlocCubit>()
                            .deleteCryptoCurrencies(data.id);
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
                builder: (context) => AddCryptoManualPage(
                      cryptoCurrenciesEntity: data,
                    )));
        if (result != null) {
          context.read<MainCryptoBlocCubit>().getCryptoCurrencies();
          // }
        }
      },
      rightTitle: '${data.value.currency} ${data.value.amount}',
    );
  }
}
