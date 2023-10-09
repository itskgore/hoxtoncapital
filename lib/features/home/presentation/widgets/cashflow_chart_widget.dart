import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/widgets/theme_echarts.dart';
import 'package:wedge/features/home/presentation/widgets/sub_widgets/section_titlebar.dart';

import '../../../../core/widgets/shimmer_container.dart';

class CashFlowChart extends StatefulWidget {
  final DashboardDataEntity dashboardDataEntity;

  const CashFlowChart({Key? key, required this.dashboardDataEntity})
      : super(key: key);

  @override
  State<CashFlowChart> createState() => _CashFlowChartState();
}

class _CashFlowChartState extends State<CashFlowChart> {
  AppLocalizations? translate;
  dynamic _webController;

  bool chartLoaded = false;

  changeLoadingState(bool val) {
    setState(() {
      chartLoaded = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return widget.dashboardDataEntity.cumulativeMonthlyCashFlow.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              children: [
                SectionTitleBarHome(title: translate!.cashFlow, onTap: null),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildInflowOutflow(
                        isInflow: true,
                        amt: numberFormat.format(widget
                            .dashboardDataEntity.data.cashflow.inflowMTD)),
                    buildInflowOutflow(
                        isInflow: false,
                        amt: numberFormat.format(widget
                            .dashboardDataEntity.data.cashflow.outflowMTD)),
                  ],
                ),
                widget.dashboardDataEntity.data.cashflow.totalInflow == 0 &&
                        widget.dashboardDataEntity.data.cashflow.totalOutflow ==
                            0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 30, horizontal: 8),
                        child:
                            Image.asset("assets/placeholders/empty_graph.png"),
                      )
                    : Stack(
                        children: [
                          SizedBox(
                            height: 300,
                            child: Echarts(
                                reloadAfterInit: true,
                                onLoad: (_) {
                                  if (_webController == null) {
                                    _webController = _;
                                    _.reload();
                                  }
                                  changeLoadingState(true);
                                },
                                onWebResourceError: (_, e) {},
                                theme: 'dark',
                                extensions: [darkThemeScript],
                                extraScript: '''
                            chart.on('click', (params) => {
                              if(params.componentType === 'series') {
                                Messager.postMessage(JSON.stringify({
                                  type: 'select',
                                  payload: params.dataIndex,
                                }));
                              }
                            });
                          ''',
                                option: '''

          {
     dataZoom: [
        {
            show: false,
            start: 94,
            end: 0
        },
        {
            type: 'inside',
            start: 94,
            end: 0
        },
       
    ],
     tooltip: {
            trigger: "axis",
              formatter:(params) => {
                                return `
                                <div> 
                                <svg height="8" width="8" class="inline"><circle cx="4" cy="4" r="4" fill="#6AAC89"/></svg> <b> ` + '${widget.dashboardDataEntity.data.baseCurrency} ' + params[0].value.toLocaleString('en-US', { currency: '${widget.dashboardDataEntity.data.baseCurrency}' }) +  `</b>
                                </div>
                                <div> 
                                <svg height="8" width="8" class="inline"><circle cx="4" cy="4" r="4" fill="#E47A77"/></svg> <b> `+'${widget.dashboardDataEntity.data.baseCurrency} ' + params[1].value.toLocaleString('en-US', { currency: '${widget.dashboardDataEntity.data.baseCurrency}' }) +  `</b>
                                <br>
                                `+ params[0].name+`
                                </div>`
                    },
            },
      grid: {
        left: '1%',
        right: '2%',
        bottom: '12%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        axisTick: { show: true },
        data: ${jsonEncode(getLast6Montths())},
        axisLabel: { 
         color: "#${darken(appThemeColors!.disableText!, .0).value.toRadixString(16).substring(2, 8)}",
         formatter: function xFormatter(value, index) {
                                return  value.substring(0,3);
                                },
             },
      },
      yAxis: {
        type: 'value',
       axisLabel: {
          color: "#${darken(appThemeColors!.disableText!, .0).value.toRadixString(16).substring(2, 8)}",
          formatter: function xFormatter(value, index) {
                                return  Math.abs(value) > 999 ? Math.sign(value)*((Math.abs(value)/1000).toFixed(1)) + 'k' : Math.sign(value)*Math.abs(value)
                                  
                                }
        },
      },
      series: [
        {
          name: 'Inflows',
          type: 'bar',
          barGap: 0,
          emphasis: {
            focus: 'series',
          },
          // itemStyle: { color: '#${darken(appThemeColors!.charts!.barCharts!.positive!, .0).value.toRadixString(16).substring(2, 8)}' },
            itemStyle: { color: '#6AAC89' },
          data: ${jsonEncode(getInflows())},
        },
        {
          name: 'Outflows',
          type: 'bar',
          barGap: 0,
          emphasis: {
            focus: 'series',
          },
          // itemStyle: { color: '#${darken(appThemeColors!.charts!.barCharts!.negative!, .0).value.toRadixString(16).substring(2, 8)}' },
           itemStyle: { color: '#E47A77' },
          data: ${jsonEncode(getOutflows())},
        }
      ]
    }

'''),
                          ),
                          chartLoaded
                              ? Container()
                              : CustomShimmerContainer(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                )
                        ],
                      ),
              ],
            ),
          );
  }

  Container buildInflowOutflow({required bool isInflow, required String amt}) {
    return Container(
      decoration: BoxDecoration(
          color: appThemeColors!.textLight,
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                RotationTransition(
                  turns: isInflow
                      ? const AlwaysStoppedAnimation(140 / 360)
                      : const AlwaysStoppedAnimation(45 / 360),
                  child: isInflow
                      ? Icon(
                          Icons.arrow_upward,
                          size: 20,
                          color: appThemeColors!.charts!.assets!.mainAsset,
                        )
                      : Icon(
                          Icons.arrow_upward,
                          size: 20,
                          color:
                              appThemeColors!.charts!.liabilties!.mainLiability,
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("${widget.dashboardDataEntity.data.baseCurrency} $amt",
                    style: TitleHelper.h11),
              ],
            ),
            const SizedBox(
              height: 4.0,
            ),
            Text(
                isInflow
                    ? translate!.currentMonthInflow
                    : translate!.currentMonthOutflow,
                style: SubtitleHelper.h12
                    .copyWith(color: appThemeColors!.disableText))
          ],
        ),
      ),
    );
  }

  List<DateTime> getMonthsInYear() {
    final dates = <DateTime>[];
    final now = DateTime.now();
    DateTime date = DateTime.now().subtract(const Duration(days: 152));
    final sixMonthFromNow = DateTime(date.year, date.month + 6);

    while (date.isBefore(sixMonthFromNow)) {
      dates.add(date);
      date = DateTime(date.year, date.month + 1);
    }
    return dates;
  }

  List<int> datesNum = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];

  //inshaf.test@acme.com
  int index = 0;

  dynamic dataDummy;

  manipulateData() {
    manipulatedData.clear();

    index = 0;
    if (widget.dashboardDataEntity.cumulativeMonthlyCashFlow.isNotEmpty) {
      for (var e in widget.dashboardDataEntity.cumulativeMonthlyCashFlow) {
        if (e[0] != "date") {
          DateTime ww =
              DateTime.fromMillisecondsSinceEpoch(e[0] * 1000).toLocal();
          if (ww.isAfter(Jiffy.now().subtract(months: 5).dateTime)) {
            manipulatedData.add([e[0], e[1], e[2]]);
          }
        }
      }
    }

    return manipulatedData;
  }

  List manipulatedData = [];

  List<String> getLast6Montths() {
    final dates = <String>[];
    manipulateData().forEach((element) {
      DateTime date =
          DateTime.fromMillisecondsSinceEpoch(element[0] * 1000).toUtc();
      if (date.month == 1) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 2) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 3) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 4) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 5) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 6) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 7) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 8) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 9) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 10) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 11) {
        dates.add(dateFormatter10.format(date));
      } else if (date.month == 12) {
        dates.add(dateFormatter10.format(date));
      }
    });
    var l = dates.length;
    return dates;
  }

  List<num> getInflows() {
    List<num> value = [];
    manipulateData().forEach((element) {
      value.add(element[1]);
    });

    return value;
  }

  List<num> getOutflows() {
    List<num> value = [];
    manipulateData().forEach((element) {
      value.add(element[2]);
    });

    return value;
  }
}
