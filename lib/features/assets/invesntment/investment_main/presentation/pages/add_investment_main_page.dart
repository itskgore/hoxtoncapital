import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/common/functions/common_functions.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/utils/wedge_app_bar.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/dashboard_value_container.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/core/widgets/dialog/wedge_comfirm_dialog.dart';
import 'package:wedge/core/widgets/wedge_expension_tile.dart';
import 'package:wedge/features/assets/bank_account/add_bank_account/presentation/pages/add_bank_page.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/presentation/pages/add_investment_manual_page.dart';
import 'package:wedge/features/assets/invesntment/investment_main/presentation/bloc/cubit/investments_cubit.dart';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_peformance_cubit.dart';
import '../../../../../../core/common/line_performance_graph/presentation/cubit/line_performance_state.dart';
import '../../../../../../core/utils/wedge_circular_progress_indicator.dart';
import '../../../../../../core/widgets/bottomSheet/duration_selector_bottomsheet.dart';
import '../../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../../core/widgets/wedge_echarts.dart';
import '../../../../../../dependency_injection.dart';
import '../../../../../your_investments/presentation/pages/your_investments_main.dart';
import '../../../../pension_investment/pension_investments_main/presentation/widgets/list_tile_inverstments.dart';

class InvestmentsMainPage extends StatefulWidget {
  InvestmentsMainPage({Key? key}) : super(key: key);

  @override
  _InvestmentsMainPageState createState() => _InvestmentsMainPageState();
}

class _InvestmentsMainPageState extends State<InvestmentsMainPage> {
  // loadGraphData(List<dynamic> data) {
  //   final List<PerformanceChartModel> chartData = [];
  //   for (var element in data) {
  //     if (element[0].isAfter(startDate) && element[0].isBefore(endDate)) {
  //       chartData.add(PerformanceChartModel(element[0],
  //           double.parse("${element[8]}") + double.parse("${element[9]}")));
  //     }
  //   }
  //   return chartData;
  // }

  List selectedDateListData = [];
  DateTime startDate = DateTime(
      DateTime.now().year, DateTime.now().month - 1, DateTime.now().day);
  DateTime endDate = DateTime.now();
  bool isDeleting = false;
  final lastDayPerformanceSummary = ValueNotifier<LastDayPerformance?>(null);

  addInvestment() async {
    await Navigator.push(
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
                            setState(() {});
                          });
                    } else {
                      // exited
                      Navigator.pop(context);
                    }
                  },
                  // subtitle: translate!.orSelectFromTheBrokersBelow,
                  manualAddButtonAction: () async {
                    final data = await Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                AddInvestmentManualPage(
                                  isFromDashboard: true,
                                )));
                    // resetState();
                    if (data != null) {
                      setState(() {});
                    }
                  },
                  manualAddButtonTitle: translate!.addManually,
                  placeholder: 'Search Investment Platforms',
                  title: '${translate!.add} ${translate!.investments}',
                )));
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      backgroundColor: appThemeColors!.bg,
      appBar: wedgeAppBar(
        context: context,
        title: translate!.investments,
        actions: IconButton(
            onPressed: () async {
              addInvestment();
            },
            icon: const Icon(Icons.add)),
      ),
      body: BlocConsumer<InvestmentsCubit, InvestmentsState>(
        bloc: context.read<InvestmentsCubit>().getData(),
        listener: (context, state) {
          if (state is InvestmentsError) {
            setState(() {
              isDeleting = false;
            });
            showSnackBar(context: context, title: state.errorMsg);
          }
          if (state is InvestmentsLoaded) {
            if (state.deleteMessageSent) {
              showSnackBar(context: context, title: translate!.assetDeleted);
              setState(() {
                isDeleting = false;
              });
            }
          }
        },
        builder: (context, state) {
          if (state is InvestmentsLoaded) {
            List<Map<String, dynamic>> modelIds = [];
            for (var e in state.assets.investments) {
              modelIds.add({'id': e.id, 'name': e.name});
            }
            modelIds.add({'id': 'total', 'name': "Total"});
            return SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    ValueListenableBuilder(
                        valueListenable: lastDayPerformanceSummary,
                        builder: (context, value, child) {
                          return DashboardValueContainer(
                            mainValue:
                                "${state.assets.summary.investments.currency} ${state.assets.summary.investments.amount}",
                            mainTitle: translate!.totalInvestmentsValue,
                            leftImage: "assets/icons/Investments.png",
                            leftValue:
                                "${state.assets.summary.investments.count}",
                            isSingleTitle: true,
                            leftTitle: translate!.investments,
                            summary: value,
                            // rightTitle: translate!.investments,
                            // rightvalue: "${state.data.summary.investments.count}",
                          );
                        }),
                    Visibility(
                      visible: (state.assets.investments.isNotEmpty),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  DurationSelectorBottomSheet(
                                    startDate: startDate,
                                    endDate: endDate,
                                    isShowMax: false,
                                    createdAt: state
                                            .assets.investments.isNotEmpty
                                        ? state.assets.investments[0].createdAt!
                                        : "",
                                    initDateList: selectedDateListData,
                                    onChange: (dates) async {
                                      startDate = dates[0];
                                      endDate = dates![1];
                                      context
                                          .read<LinePerformanceCubit>()
                                          .getLinePerformanceData(
                                              merge: true,
                                              scope: ['fi'],
                                              isFiltered: false,
                                              fromDate: dateFormatter5
                                                  .format(startDate),
                                              toDate: dateFormatter5
                                                  .format(endDate),
                                              assetType: 'investment',
                                              isPerformance: false);
                                      setState(() {
                                        selectedDateListData = dates;
                                      });
                                      await Future.delayed(
                                          const Duration(milliseconds: 500));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              BlocConsumer<LinePerformanceCubit,
                                      LinePerformanceState>(
                                  bloc: context
                                      .read<LinePerformanceCubit>()
                                      .getLinePerformanceData(
                                          merge: true,
                                          scope: ['fi'],
                                          isFiltered: false,
                                          fromDate: dateFormatter5.format(
                                              DateTime(
                                                  DateTime.now().year,
                                                  DateTime.now().month - 1,
                                                  DateTime.now().day)),
                                          toDate: dateFormatter5.format(
                                            DateTime.now(),
                                          ),
                                          assetType: 'investment',
                                          isPerformance: false),
                                  listener: (context, state) {
                                    if (state is LinePerformanceLoaded) {
                                      lastDayPerformanceSummary.value = state
                                          .linePerformanceModel
                                          .merge
                                          ?.fi
                                          ?.lastDayPerformanceSummary;
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LinePerformanceLoaded) {
                                      return SizedBox(
                                          width: size.width,
                                          height: size.height * .25,
                                          child: WedgeEcharts(
                                              index: 2,
                                              isFiltered: state.isFiltered,
                                              currency: state.baseCurrency,
                                              data: state.data));
                                    } else {
                                      return buildCircularProgressIndicator(
                                          width: 20);
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${translate!.investments} (${state.assets.investments.length})",
                          style: TitleHelper.h9,
                        ),
                        AppButton(
                            onTap: () async {
                              addInvestment();
                            },
                            label: translate!.add)
                      ],
                    ),
                    state.assets.investments.isEmpty
                        ? FittedBox(
                            child: Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: Row(
                                children: [
                                  Text(
                                    translate!.noDataAvai,
                                    style: TextHelper.h5.copyWith(
                                        fontWeight: FontWeight.normal),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      addInvestment();
                                    },
                                    child: Text(
                                      "${translate!.add} ${translate!.investments}",
                                      style: TextHelper.h6.copyWith(
                                          fontWeight: FontWeight.normal,
                                          color: appThemeColors!.outline),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              // AggregationResultChart(
                              //   modelId: modelIds,
                              //   isHolding: false,
                              //   type: AggregationChartType.Investment,
                              // ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: state.assets.investments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _listTileInvestments(
                                      index, state.assets.investments[index]);
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else if (state is InvestmentsLoading) {
            return Center(
              child: buildCircularProgressIndicator(width: 150),
            );
          } else if (state is InvestmentsError) {
            return Center(
              child: Text(state.errorMsg),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _listTileInvestments(index, InvestmentEntity data) {
    var source = data.source?.toLowerCase();
    if (source == 'manual') {
      return WedgeExpansionTile(
        leading: Image.asset(
          "assets/icons/persoanlLoanMainContainer.png",
          height: 40,
          width: 40,
        ),
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(vertical: 10),
        borderRadius: 10,
        index: index,
        leftTitle: data.name,
        leftTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
        rightSubTitle: 'Manual',
        rightSubtitleStyle: SubtitleHelper.h11,
        rightTitle:
            "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}",
        rightTitleStyle: TitleHelper.h10.copyWith(color: Colors.black),
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
                    translate!.policyNumber,
                    style: SubtitleHelper.h11,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    translate!.initialValue,
                    style: SubtitleHelper.h11,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(data.policyNumber.isEmpty ? "Nil" : data.policyNumber),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "${data.initialValue.currency} ${numberFormat.format(data.initialValue.amount)}",
                    style: SubtitleHelper.h11,
                  ),
                ],
              ),
            ],
          ),
        ),
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

                          context.read<InvestmentsCubit>().deleteData(data.id);
                          Navigator.pop(context);
                        },
                        deniedPress: () {
                          Navigator.pop(context);
                        },
                        acceptText: translate!.yesDelete,
                        deniedText: translate!.noiWillKeepIt));
              },
        onEditPressed: isDeleting
            ? null
            : () async {
                var result = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => AddInvestmentManualPage(
                              assetData: data,
                            )));
                if (result != null) {}
              },
      );
    } else {
      return Stack(
        children: [
          ListTileInvestment(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => YourInvestmentsMain(
                            investmentEntity: data,
                          ))).then((value) => {
                    context.read<InvestmentsCubit>().getData(),
                  });
            },
            leading: source != "hoxton"
                ? SvgPicture.network(
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
                  )
                : Image.asset(
                    "assets/icons/persoanlLoanMainContainer.png",
                    height: 40,
                    width: 40,
                  ),
            title: data.providerName != '' ? data.providerName : data.name,
            source: source,
            subTitle: data.providerName != '' ? data.name : "",
            saltedgeData: data,
            trailing:
                "${data.currentValue.currency} ${numberFormat.format(data.currentValue.amount)}",
          ),
        ],
      );
    }
  }
}
