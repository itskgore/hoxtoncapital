import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/data/models/chart_data_pension_investment.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/presentation/widgets/theme_echarts.dart';

import '../../../../core/widgets/shimmer_container.dart';

class WedgeEcharts extends StatefulWidget {
  final List data;
  final String currency;
  final int? index;
  final bool isFiltered;
  final bool? showTransDate;

  const WedgeEcharts({
    super.key,
    required this.data,
    required this.currency,
    required this.isFiltered,
    this.showTransDate,
    this.index,
  });

  @override
  State<WedgeEcharts> createState() => _WedgeEchartsState();
}

class _WedgeEchartsState extends State<WedgeEcharts> {
  DateTime startDate = Jiffy.now().add(months: 7).dateTime;
  List<int> intervals = [30];
  List<ChartDataModel> chartData = [];
  List<charts.Series<ChartDataModel, DateTime>> chartMappingData = [];

  @override
  initState() {
    getChartData();
    super.initState();
  }

  getDateDifference() {
    DateTime firstDate = getLast6MonthsDateTime()[0];
    DateTime lastDate =
        getLast6MonthsDateTime()[getLast6MonthsDateTime().length - 1];
    int dayDifference = firstDate.difference(lastDate).inDays.abs();
    return dayDifference;
  }

  void getChartData() {
    for (var element in widget.data) {
      chartData.add(
        ChartDataModel(
          total: double.parse(element[widget.index ?? 6].toString()),
          valuationDate: DateTime.parse(element[0].toString()).toUtc(),
        ),
      );
    }

    chartMappingData = [
      charts.Series<ChartDataModel, DateTime>(
        id: 'Mobile',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (ChartDataModel sales, _) => sales.valuationDate,
        measureFn: (ChartDataModel sales, _) => sales.total,
        displayName: "asdadas",
        overlaySeries: false,
        data: chartData,
      ),
    ];
  }

  List<String> getLast6Months() {
    final dates = <String>[];

    for (var element in chartData) {
      if (element.valuationDate.month >= 1 &&
          element.valuationDate.month <= 12) {
        dates.add(dateFormatter12.format(element.valuationDate));
      }
    }
    return dates;
  }

  List<DateTime> getLast6MonthsDateTime() {
    final dates = <DateTime>[];
    for (var element in chartData) {
      if (element.valuationDate.month >= 1 &&
          element.valuationDate.month <= 12) {
        dates.add(element.valuationDate);
      }
    }
    return dates;
  }

  //TODO : chartData if not properly formatting data
  List<Map<String, dynamic>> listOfValue() {
    List<Map<String, dynamic>> value = [];
    for (var element in chartData) {
      value.add({
        "name": element.valuationDate.toIso8601String(),
        "value": [
          element.valuationDate.millisecondsSinceEpoch,
          element.total,
        ],
      });
    }
    return value;
  }

  bool chartLoaded = false;
  changeLoadingState(bool val) {
    setState(() {
      chartLoaded = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final simpleCurrencyFormatter =
        charts.BasicNumericTickFormatterSpec.fromNumberFormat(
      NumberFormat.compact(),
    );
    return Container(
      color: kBackgroundColor,
      child: Stack(
        children: [
          Echarts(
            reloadAfterInit: true,
            onLoad: (_) {
              changeLoadingState(true);
            },
            onWebResourceError: (_, e) {
              // print(e.toString());
            },
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
                tooltip: {
                  trigger: "axis",
                  formatter: (params) => {
                    const month = ["January","February","March","April","May","June","July","August","September","October","November","December"];
                    const d = new Date(params[0].name);
                    if (${getDateDifference() <= 7 || getDateDifference() <= 31}) {
                      return "<b>${widget.currency} " + params[0].value[1].toLocaleString('en-US', {currency: '${widget.currency}' }) + "</b><br>" + d.getUTCDate() + " " + month[d.getMonth()] + " " +  d.getFullYear();
                    } else {
                      return "<b>${widget.currency} " + params[0].value[1].toLocaleString('en-US', {currency: '${widget.currency}' }) + "</b><br>" + d.getUTCDate() + " " + month[d.getUTCMonth()] + " " +  d.getFullYear();
                    }
                  },
                },
                grid: {
                  left: "3%",
                  right: "4%",
                  bottom: "3%",
                  containLabel: true,
                  height: '90%',
                },
                xAxis: {
                  type: "${getDateDifference() <= 7 ? "category" : 7 < getDateDifference() && getDateDifference() <= 31 ? "category" : "time"}",
                  min: function (value) {
                    return value.min;
                  },
                  max: function (value) {
                    return value.max + 0.05;
                  },
                  minInterval: ${getDateDifference() <= 100 ? '1000 * 24 * 60 * 60 * 20' : '1000 * 24 * 60 * 60 * 30'},
                  axisLabel: {
                    showMaxLabel: true,
                    showMinLabel: ${getDateDifference() <= 365 ? 'true' : 'false'},
                    hideOverlap: true,
                    formatter: function xFormatter(value, index) {
                      const month = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sept","Oct","Nov","Dec"];
                      const day = ["Sun", "Mon","Tue","Wed","Thu","Fri","Sat"];
                      if (${getDateDifference() <= 7}) {
                        if (${widget.showTransDate ?? false}) {
                          return (new Date(Number(value))).getUTCDate();
                        } else {
                          return day[(new Date(Number(value))).getUTCDay()];
                        }
                      } else if (${getDateDifference() <= 31}) {
                        return (new Date(Number(value))).getUTCDate();
                      } else if (${31 < getDateDifference() && getDateDifference() <= 365}) {
                        return (new Date(Number(value))).getUTCDate() + " " + month[(new Date(Number(value))).getUTCMonth()];
                      } else if (${getDateDifference() > 365}) {
                        return month[(new Date(Number(value))).getUTCMonth()] + " " + (new Date(Number(value))).getUTCFullYear();
                      } else {
                        return 'value.substring(0,6)';
                      }
                    },
                  },
                  boundaryGap: false,
                  nameTextStyle: {
                    color: "rgba(0, 0, 0, 1)",
                  },
                },
                yAxis: {
                  type: 'value',
                  min: function (value) {
                    return value.min - (value.min < 0 ? ((value.min * -1) * 0.05) : ((value.min) * 0.05));
                  },
                  max: function (value) {
                    return value.max + (value.max * 0.05);
                  }, 
                  axisLabel: {
                    formatter: function xFormatter(value, index) {
                      return Intl.NumberFormat('en-US', {currency: '${widget.currency}', maximumSignificantDigits: 3,notation: "compact",compactDisplay: "short"}).format(value);
                    },
                  },
                },
                axisLabel: {
                  color: "#0000000",
                  fontWeight: "lighter",
                },
                series: {
                  name: "Performance",
                  type: "line",
                  showSymbol: false,
                  itemStyle: {
                    color:  '#4287f5',
                  },
                  stack: "Total",
                  data: ${jsonEncode(listOfValue())},
                },
              }
            ''',
          ),
          chartLoaded
              ? const SizedBox.shrink()
              : CustomShimmerContainer(
                  height: MediaQuery.of(context).size.height * .25),
        ],
      ),
    );
  }
}
